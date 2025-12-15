% ChooseBestMove - Determines the optimal move for a 2048 board using a heuristic scoring system.
% The function iterates through all four possible move directions. For each valid move, it applies
% the move using MakeMove and evaluates the resulting board using a heuristic based on: 
% the immediate move score, number of empty tiles, monotonicity of rows/columns,
% smoothness of tile values, and corner strategy (having the highest value tile in a corner). 
% The function returns the move direction with the highest heuristic score and the corresponding score value.
function [best_direction, max_score] = ChooseBestMove(board)
	
	% Creating an array of all possible move directions.
	% Iterating through all of these ensures every option is considered
	% before choosing the best move.
    directions = ["u" "d" "l" "r"];
	% Initializes the value of the maximum heuristic score to an extremely low value.
	% If the board configuration is poor, a negative heuristic score is possible. 
	% Such a low value ensures that playing a valid move overrides it, thus producing a valid heuristic score.
    max_score = -10000;    
	
	% Initializes the best direction. This value represens what happens in the event of a jammed
	% board (one where no move is possible).
	% This value is overwritten in the event that a valid move is found.
    best_direction = 'none';
	
    
    
% Helper function - Monotonic
% Monotonicity: values in a row or column are consistently increasing or decreasing.
% Boards with higher monotonicity (tiles decreasing in value along rows or columns)
% are preferred because placing high value tiles in a corner and maintaining sequential order
% makes it easier to combine tiles in future moves.
function [score] = Monotonic(board)
	% Initializes the monotonicity score.
    score = 0;
	
% The function iterates through all rows and columns, checking the differences
% between each tile and its neighboring tile in both directions. Only decreases are added to the
% score through sum, while increases or equal values contribute nothing. By evaluating each
% row left-to-right and right-to-left (and each column top-to-bottom and
% bottom-to-top), the function is able to recognize monotonicity regardless of
% whether the tiles increase or decrease overall. The score represents the total
% magnitude of these decreasing differences across the board: larger differences
% contribute more, indicating stronger monotonicity, while smaller or zero
% differences contribute less, reflecting weaker monotonicity. High monotonicity
% is desirable because it favors board configurations where high-value tiles are
% grouped in a corner and decrease smoothly across the row or column, making
% future merges more likely.

	% Checking monotonicity across rows
    for r = 1:4
        % Evaluate monotonicity from left to right.
        % If the value to the right is smaller, update the score with the
        % difference between the value and its neighbor to the right.
        for c = 1:3
            if board(r,c) >= board(r,c+1)
                score = score + (board(r,c) - board(r,c+1));
            end
        end
        
        % Similar logic as above: check in the opposite direction and
        % increase the score if decreases from right to left are found.
        for c = 4:-1:2
            if board(r,c) >= board(r,c-1)
                score = score + (board(r,c) - board(r,c-1));
            end
        end
    end

    % Checking monotonicity along columns
    for c = 1:4
        % Similar logic: check from top to bottom and increase the score if
        % decreases are found in this direction.
        for r = 1:3
            if board(r,c) >= board(r+1,c)
                score = score + (board(r,c) - board(r+1,c));
            end
        end
        
        % Similar logic: check from bottom to top and increase the score if
        % decreases are found in this direction.
        for r = 4:-1:2
            if board(r,c) >= board(r-1,c)
                score = score + (board(r,c) - board(r-1,c));
            end
        end
    end

end

% Helper function - Smoothness
% Smoothness: variance in values of neighboring tiles.
% A smooth board has neighboring tiles with similar values. Smoothness is desirable
% because it increases the likelihood of combining tiles in future moves.
% Measures difference between tiles i.e. 1024 next to 512 is a distance 
% of 1 due to the log function(log(1024)/log(2) = 10 and log(512)/log(2) = 9).
% Smoothness measures how far apart tiles are and not whether one is larger.
% Taking the absolute value ensures that the difference is treated the same
% regardless of which number is larger, giving a consistent evaluation of smoothness.
% For this function, the score is negative. Values closer to 0 indicate a smoother board,
% while larger negative values indicate roughness (more penalty).
function score = Smoothness(board)
	% Initialzes the smoothness score as 0.
    score = 0;
    
    % Differences across tiles within rows
    for i = 1:4
        for j = 1:3
		 % Subtract the absolute value of the difference in log2(tile values) from the score.
         % Larger differences penalize the score more, smaller differences less.
		 % Only applicable to nonzero tile values.
		 % The score is subtracted by this difference so that larger differences
		 % (rougher boards) reduce the smoothness score, while smaller differences
		 % (smoother boards) reduce it less.
            if board(i,j) ~= 0 && board(i,j+1) ~= 0              
                score = score - abs(log2(board(i,j)) - log2(board(i,j+1)));
            end
        end
    end
    
    % Differences across tiles within columns
	% Uses the same logic as for rows, but checks from top to bottom (columnwise)
    for i = 1:3
        for j = 1:4
            if board(i,j) ~= 0 && board(i+1,j) ~= 0
                score = score - abs(log2(board(i,j)) - log2(board(i+1,j)));
            end
        end
    end
end

% Helper function - cornerStrategy
% This heuristic rewards placement of the highest value tile in a corner.
% Placing the highest value tile in the corner reduces it's likelihood of being
% displaced by future moves, enabling monotonic chains of tiles to be constructed
% around it. 
% In this state, merges tend to propagate towards this fixed point rather than being
% scattered across the board. 
% Because this factor is strategically more significant than board smoothness or monotonicity,
% a fixed bonus is applied whenever the largest tile is in a corner.
function corner_score = cornerStrategy(board)
    % Finds the highest tile value on the board by scanning each position.
	max_tile = 0;
	for r = 1:4
		for c = 1:4
			if board(r,c) > max_tile
				max_tile = board(r,c);
			end
		end
	end
				
	% Obtains the tile value from each corner position and saves for comparison.
	top_left = board(1,1);
	top_right = board(1,4);
	bottom_left = board(4,1);
	bottom_right = board(4,4);
	
	% Applies the fixed heuristic bonus if the largest tile occupies the corner.
	% If it doesn't occupy the corner, no bonus score is applied.
	% The magnitude of the bonus (1000) is intentionally large relative to
    % the smoothness and monotonicity penalties so that corner placement acts as
    % a primary decision driver rather than being overpowered by the other heuristics.
	if max_tile == top_left || max_tile == top_right || max_tile == bottom_left || max_tile == bottom_right
		corner_score = 1500;
	else
		corner_score = 0;
	end
end

% Helper function - EvaluateMove
% This function evaluates a single move direction by calling MakeMove to "play"
% the move. The resulting board state is analyzed using multiple
% heuristics: number of empty tiles, monotonicity of rows/columns, smoothness of
% neighboring tile values, and corner placement of the highest tile. Each heuristic
% is weighted and summed to produce a single heuristic score for that move. 
% The score reflects the overall desirability of the move, guiding ChooseBestMove
% to select the direction with the highest heuristic score.
function [heuristic_score] = EvaluateMove(board, direction)
    % Call MakeMove to play the move and give the move score and resulting board.
    [new_board, move_score] = MakeMove(board, direction);
    
    % Calculates resulting heuristic scores after the move is complete.
	
	% Finds the number of empty tiles. Having more is better for this heuristic.
    emptyTiles = sum(new_board(:) == 0);
	% Monotonicity score prefers having decreasing sequences.
    mScore = Monotonic(new_board);
	% Smoothness score penalizes neighboring tiles of largely differing values.
    smoothScore = Smoothness(new_board);
	% Corner strategy score rewards having the largest tile in a corner with a high bonus.
    cornerScore = cornerStrategy(new_board);
    
    % Weights heuristics according to their overall strategic importance.
	
	% Give an immediate reward. This has a low weight, since short term merges are
	% not as critical as preserving board structure.
    scoreWeight = 200.0;  
	
	% Heavily favor keeping tiles free. This has a very high weight because empty
	% spaces are critical for avoiding jammed boards and enabling future moves.
    emptyWeight = 400.0;     

	% Consistently decreasing tile values are important to keeping high-value tiles in the corner.
	% This is moderately weighted.
    monotonicityWeight = 0.5; 
	
	% Similar neighboring tiles are critical to ensuring future moves. This heuristic moderately penalizes
	% rough boards because they are not conducive to making merges in the future.
    smoothnessWeight = 100.0; 
	
	% Having a high-scoring tile in the corner has a low weight because it is a fixed high-value reward.
	% This promotes the long-term ability to maintain an orientation of tiles that is conducive to merging.
    cornerWeight = 1.0; 
	
    
	% Applies the weight factors to each heuristic score
    moveFactor = scoreWeight * move_score;
    emptyFactor = emptyWeight * emptyTiles;
    monotonicityFactor = monotonicityWeight * mScore;
    smoothnessFactor = smoothnessWeight * smoothScore;
    cornerFactor = cornerWeight * cornerScore;

	% Combines individual heuristic scores into the final score after weighting.
    heuristic_score = moveFactor + emptyFactor + monotonicityFactor + smoothnessFactor + cornerFactor;
end

% Calls the helper functions, iterates through move directions, and determines the best outcome.

    for i = 1:length(directions)
        direction = directions(i);
        
        % Calls MakeMove to "play" the move on the board.
		% Returns the new board state and the immediate move score (points earned from merges).
        [new_board, ~] = MakeMove(board, direction);
 		% Checks if no change occurred from the attempted move.
		% isequal compares the entire new_board and board matrices element-wise.
		% This function returns true only if every tile matches. 
		% In cases where the board does not change, a heuristic calculation is unnecessary.
		% If the game state is different, proceed with the evaluation.
        if isequal(new_board, board)            
            continue;
        end
        
        % Evaluates this move direction using the heuristic scoring system.
        heuristic_score = EvaluateMove(board, direction);
        
        % Tracks best move direction, heuristic, and board score so far. 
		% If the move has a higher heuristic score than a previous move,
		% update the max score and best direction accordingly.
        if heuristic_score > max_score
            max_score = heuristic_score;
            best_direction = direction;
        end

    end
end
