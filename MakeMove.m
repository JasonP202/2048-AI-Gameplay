function [new_board, score] = MakeMove(board, direction)
score = 0; % initial score

 % Creates variables for board size and score.
    w = width(board);
    h = height(board);
    % Working copy of the board to apply intermediate moves and merges without altering original input.
    upd_Brd = board;
    % Placeholder for the final post-move board state. This remains empty until the Combine function
    % produces the merged result, ensuring the original board isn't gradually mutated.
    new_board = [];  
    
	% Creates a cell array to hold coordinates of equal value neighboring tiles.
    % This is used because a cell expands and prepopulates as empty instead of zero.
    % This prevents invalid coordinates from being stored.
    coords = {};
    
    % The following helper functions were developed under the assumption that full 2048 functionality
    % would be required, including random tile spawning after each move. The final project specification
    % does not explicitly mention this mechanic, so these remain commented-out intentionally.
    
	
    % Creates a helper function to return the coordinates of empty tiles.
    % This function returns the position of zeros in column-major format.
	% Initially, I thought the project would require considering how random
	% tiles populate in empty spaces after each move. This was not mentioned 
	% in the project specifications and is not used.
    function [arr] = Zeros(board)
        arr = [];
        arr = find(board(:,:) == 0);
    end
    
    % Creates a helper function to place a value of 2 or 4 in a random empty
	% tile as in the official game.
    % 2 has an 80% chance to populate.
	% As with the helper function above, this code is unused.
    function [upd_Brd] = RandomTile(board)
        zerosFromBoard = Zeros(board);
        if zerosFromBoard ~= 0
            choices = [2 2 2 2 2 2 2 2 2 4];
            TwoOrFour = choices(randi([1, 10]));
            numZeros = length(zerosFromBoard);
            randTilepos = zerosFromBoard(randi([1, numZeros]));
            upd_Brd = board;
            upd_Brd(randTilepos) = TwoOrFour; 
        else
          upd_Brd = board;
        end
    end
    
    
    % Helper function: shift all nonzero tiles upward in each column.
	% Returns the updated board after moving tiles up and pushing zeros down.
    function [upd_Brd] = moveUp(board)
    upd_Brd = zeros(size(board));
	% Iterate over each column, preserving the order of nonzero tiles,
    % then append zeros to the bottom of the column.
        for c = 1:size(board,2)
            col = board(:,c);			
            upd_Brd(:,c) = [col(col ~= 0); col(col == 0)];
        end
    
    end
    
    % Helper function: shift all nonzero tiles downward in each column.
	% Similar to moveUp but pushes zeros to the top instead of bottom.
    function [upd_Brd] = moveDown(board)
    upd_Brd = zeros(size(board));
        for c = 1:size(board,2)
            col = board(:,c);
            upd_Brd(:,c) = [col(col == 0); col(col ~= 0)];
        end
    
    end
    
    % Helper function: shift all nonzero tiles left in each row.
	% Similar to moveUp but operates row-wise, pushing zeros to the right.
    function [upd_Brd] = moveLeft(board)
    upd_Brd = zeros(size(board));
        for r = 1:size(board,1)
            row = board(r,:);
            upd_Brd(r,:) = [row(row ~= 0), row(row == 0)];
        end
    
    end
    
    % Helper function: shift all nonzero tiles right in each row.
	% Similar to moveDown but operates row-wise, pushing zeros to the left.
    function [upd_Brd] = moveRight(board)
    upd_Brd = zeros(size(board));
        for r = 1:size(board,1)
            row = board(r,:);
            upd_Brd(r,:) = [row(row == 0), row(row ~= 0)];
        end
    
    end
    
    % Proper 2048 game play order: move, merge, move
   
    
    % Helper function: find coordinates of adjacent equal tiles eligible for merging.
	% Scans board in direction-specific order so first coordinate in each pair
	% is always closest to the move direction (top/bottom/left/right).
	% Returns updated coords cell array with [row, col] pairs.
    function [coords] = checkEquals(upd_Brd, direction, coords)
        switch direction
			% Scan top-to-bottom in each column (save the coordinate of the one closest to top first).
			case 'u'
                for c = 1:w
					temp = [];
                    for r = 1:h-1
						% Record position if tiles are equal and nonzero.
                        if upd_Brd(r,c) == upd_Brd(r+1,c) && (upd_Brd(r,c) ~= 0) 
                            temp = [temp, r, c];
                        end
                    end
					% Prevents appending empty row and column indices to the coords cell array.
					if ~isempty(temp)
						coords{end+1} = temp;						
                    end
                end
            case 'd'
			% Scan bottom-to-top in each column (save the coordinate of the one closest to bottom first).
                for c = 1:w
					temp = [];
                    for r = h:-1:2
                        if upd_Brd(r,c) == upd_Brd(r-1,c) && (upd_Brd(r,c) ~= 0)
                            temp = [temp, r, c];
                        end
                    end
					if ~isempty(temp)
						coords{end+1} = temp;
                    end            
                end
            case 'l'
			% Scan left-to-right in each row (save the coordinate of the one closest to left first).
                for r = 1:h
                    temp = [];
                    for c = 1:w-1
                        if upd_Brd(r,c) == upd_Brd(r,c+1) && (upd_Brd(r,c) ~= 0)
                            temp = [temp, r, c];
                        end
                    end
                    if ~isempty(temp)
						coords{end+1} = temp;
                    end
                end
            case 'r'
			% Scan right-to-left in each row (save the coordinate of the one closest to right first).
                for r = 1:h
                    temp = [];
                    for c = w:-1:2
                        if upd_Brd(r,c) == upd_Brd(r,c-1) && (upd_Brd(r,c) ~= 0)                             
                            temp = [temp, r, c];
                        end
                    end
                    if ~isempty(temp)
						coords{end+1} = temp;
                    end
                    
                end
        end
    end



	% Helper function: merge equal tile pairs and update score.
	% Uses pre-computed coordinates from checkEquals. For each pair [r,c],
	% merges into the tile closest to move direction and zeros the other.
    function [upd_Brd,score] = Combine(upd_Brd,direction,coords,score) 
			% Iterate through each set of coordinate pairs found for a direction.
			for j = 1:length(coords)
				col_Pairs = coords{j};
				% Stepping by 2 gives [row,col] coordinates.
				for i = 1:2:length(col_Pairs)-1 
					r = col_Pairs(i);	% Gives the row position of the tile.
					c = col_Pairs(i+1);	% Gives the column position of the tile.
					switch direction
						case 'u'
							% Merge upward: combine row r with row r+1 into r.
							if upd_Brd(r,c) == upd_Brd(r+1,c)
								upd_Brd(r,c) = upd_Brd(r,c) + upd_Brd(r+1,c);
								% After the values are merged, the lower tile becomes zero.
								upd_Brd(r+1,c) = 0;
								% Add merged value to score
								score = score + upd_Brd(r,c);
							end
							
						case 'd'
							% Merge downward: combine row r with row r-1 into r.
							if upd_Brd(r,c) == upd_Brd(r-1,c)
								upd_Brd(r,c) = upd_Brd(r,c) + upd_Brd(r-1,c);
								upd_Brd(r-1,c) = 0;
								score = score + upd_Brd(r,c);								
							end

                        case 'l'
							% Merge leftward: combine col c with col c+1 into c.
							if upd_Brd(r,c) == upd_Brd(r,c+1)
								upd_Brd(r,c) = upd_Brd(r,c) + upd_Brd(r,c+1);
								upd_Brd(r,c+1) = 0;
								score = score + upd_Brd(r,c);								
							end

						case 'r'
							% Merge rightward: combine col c with col c-1 into c.
							if upd_Brd(r,c) == upd_Brd(r,c-1)
								upd_Brd(r,c) = upd_Brd(r,c) + upd_Brd(r,c-1);
								upd_Brd(r,c-1) = 0;
								score = score + upd_Brd(r,c);
							end
					end
				end
			end
    
    
    end

    % Follow 2048 move order. Step one is to move.
    switch direction
        case 'u'
            upd_Brd = moveUp(upd_Brd);
    
        case 'd'
            upd_Brd = moveDown(upd_Brd);
    
        case 'l'
           upd_Brd = moveLeft(upd_Brd);      
    
        case 'r'
            upd_Brd = moveRight(upd_Brd);        
    
    end
	% Perform the merge by checking for equal neigbors and updating the score.
    [coords] = checkEquals(upd_Brd, direction, coords);
    [new_board,score] = Combine(upd_Brd, direction, coords, score);  

    % Second move required by 2048 rules. Merging creates interior zeros, so this shift properly places zeros
    % and prevents a merged tile from merging again in the same turn.
    switch direction
        case 'u'
            new_board = moveUp(new_board);
    
        case 'd'
            new_board = moveDown(new_board);
    
        case 'l'
           new_board = moveLeft(new_board);      
    
        case 'r'
            new_board = moveRight(new_board);        
    
    end

    new_board = RandomTile(new_board);
end


