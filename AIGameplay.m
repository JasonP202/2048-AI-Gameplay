function [arr] = Zeros(board)
        arr = [];
        arr = find(board(:,:) == 0);
end

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

coords = [];


% Helper function: find coordinates of adjacent equal tiles eligible for merging.
% Scans board in direction-specific order so first coordinate in each pair
% is always closest to the move direction (top/bottom/left/right).
% Returns updated coords cell array with [row, col] pairs.
function [coords] = checkEquals(board, coords)
    		% Scan top-to-bottom in each column (save the coordinate of the one closest to top first).
    w = width(board);
    h = height(board);
        for c = 1:w
			temp = [];
            for r = 1:h-1
				% Record position if tiles are equal and nonzero.
                if board(r,c) == board(r+1,c) && (board(r,c) ~= 0) 
                    temp = [temp, r, c];
                end
            end
			% Prevents appending empty row and column indices to the coords cell array.
			if ~isempty(temp)
				coords{end+1} = temp;						
            end
        end
   
	% Scan bottom-to-top in each column (save the coordinate of the one closest to bottom first).
        for c = 1:w
			temp = [];
            for r = h:-1:2
                if board(r,c) == board(r-1,c) && (board(r,c) ~= 0)
                    temp = [temp, r, c];
                end
            end
			if ~isempty(temp)
				coords{end+1} = temp;
            end            
        end
    
	% Scan left-to-right in each row (save the coordinate of the one closest to left first).
        for r = 1:h
            temp = [];
            for c = 1:w-1
                if board(r,c) == board(r,c+1) && (board(r,c) ~= 0)
                    temp = [temp, r, c];
                end
            end
            if ~isempty(temp)
				coords{end+1} = temp;
            end
        end
 
	% Scan right-to-left in each row (save the coordinate of the one closest to right first).
        for r = 1:h
            temp = [];
            for c = w:-1:2
                if board(r,c) == board(r,c-1) && (board(r,c) ~= 0)                             
                    temp = [temp, r, c];
                end
            end
            if ~isempty(temp)
				coords{end+1} = temp;
            end
            
        end
end




% Enter the desired board and direction values 
% Then, run your program and output the board and score

board = [ 0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0];  % change as desired
% Start the game with 2 random tiles in random positions
board = RandomTile(board);
board = RandomTile(board);
disp(board)
pixels = DrawGame(board,0);
imshow(pixels)
% dirs = ["u", "d", "l", "r"];
numZeros = Zeros(board);
upd_Score = 0;
availMove = checkEquals(board,coords);
con1 = ~isempty(availMove);
con2 = 1;
count = 0;



while con1 || con2
    direction = ChooseBestMove(board);
    [new_board, score] = MakeMove(board, direction);
    board = new_board;
    upd_Score = score + upd_Score;
    % pixels = DrawGame(board,upd_Score);
    % imshow(pixels)
    fprintf('Score for this move: %g\n', upd_Score)
    numZeros = Zeros(board);
    availMove = checkEquals(board,coords);
    con1 = ~isempty(availMove);
    if numZeros > 0
        con2 = 1;
    else
        con2 = 0;
    end
    % pause(.5)
    count = count+1;
end
fprintf('Number of Moves: %d',count)