% DrawGame - Draws a 2048 game board as an RGB image overlaid on desktop background.
% The function takes in a board as a 4*4 matrix and outputs pixels, a uint8 RGB image.
% Creates a 504x504 board with 122px tiles + 8px borders/grid lines matching test case appearances.
% Game board overlays randomly on desktop for visual interest. Saves the game image as '2048_game.png'.
function[pixels] = DrawGame(board,score)
% Blank image to draw board over
pixels = uint8(zeros(504,504,3));

% Board geometry: 4*4 grid of tiles 122px = 488px + 2 8px borders = 504px total.
% Outer borders; 8px thick RGB = 187, 173, 160 matches test case colors.
% 8 px offset applied to starting and ending rows and columns.

% Top border
pixels(1:8, :, 1) = 187;
pixels(1:8, :, 2) = 173;
pixels(1:8, :, 3) = 160;

% Bottom border
pixels(496:504, :, 1) = 187;
pixels(496:504, :, 2) = 173;
pixels(496:504, :, 3) = 160;

% Left border
pixels(:, 1:8, 1) = 187;
pixels(:, 1:8, 2) = 173;
pixels(:, 1:8, 3) = 160;

% Right border
pixels(:, 496:504, 1) = 187;
pixels(:, 496:504, 2) = 173;
pixels(:, 496:504, 3) = 160;


% Tile dimension parameter used to determine offsets from the borders.
tileWidth = 122;

% Offset variables for the text appearing in the center of each tile.
% When using insertText, position of the number within the tile is determined by
% the distance between its top left corner and the top left corner of the number's text box. 
% Row and column offsets vary with how many digits the number has and font size.

oneDigitR = 14;
oneDigitC = 32;
twoDigitR = 14;
twoDigitC = 16;
threeDigitR = 16;
threeDigitC = 4;
fourDigitR = 20;
fourDigitC = 2;
fiveDigitR = 25;
fiveDigitC = -3;
sixDigitR = 30;
sixDigitC = -4;

% Loop through 4*4 board to apply necessary offsets for tile creation.
for r = 1: height(board) 
    for c = 1: width(board)
		% Start and ends are offset by 9 px to avoid overlapping with the borders.
        rowStart = (r-1) * tileWidth + 9;
        rowEnd = r * tileWidth + 9;
        colStart = (c-1) * tileWidth + 9;
        colEnd = c * tileWidth + 9;
		% Creating offset values to help position text centrally within a tile.
		% The values were determined experimentally and use the board's top left 
		% corner as the reference point.
        tOffRow = (r-1) * tileWidth + 15;
        tOffCol = (c-1) * tileWidth + 8;
		
		% Using previously determined RGB values to fill the respective squares.
		% insertText with a bold font to match the style of the test images.
		% This MATLAB function requires the image where you wish to insert text,
		% the position, text, and specifiers about font, color, and the text box around the number.
		% Numbers 2 and 4 are black, while the rest are white, matching the game's aesthetics.
		% One and two digit numbers have a font size of 42px.
		% Three digit numbers have a font size of 40px.
		% Four digit numbers have a font size of 36px.
        switch board(r,c)
            case 0                
                R = 205;
                G = 193;
                B = 180;
                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;                
                

            case 2
                R = 238;
                G = 228;
                B = 218;

                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + oneDigitC, tOffRow + oneDigitR],'2','Font','DejaVuSans-Bold' , 'FontSize',42, 'TextColor', 'black', 'TextBoxColor', 'white', 'BoxOpacity', 0);               

            case 4 
                R = 237;
                G = 224;
                B = 200;

                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + oneDigitC, tOffRow + oneDigitR],'4','Font','DejaVuSans-Bold' , 'FontSize',42, 'TextColor', 'black', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      

            case 8
                R = 242;
                G = 177;
                B = 121;

                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + oneDigitC, tOffRow + oneDigitR],'8','Font','DejaVuSans-Bold' , 'FontSize',42, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      


            case 16
                R = 245;
                G = 149;
                B = 99;

                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + twoDigitC, tOffRow + twoDigitR],'16','Font','DejaVuSans-Bold' , 'FontSize',42, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      

            case 32
                R = 246;
                G = 94;
                B = 59;

                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + twoDigitC, tOffRow + twoDigitR],'32','Font','DejaVuSans-Bold' , 'FontSize',42, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      

            case 64
                R = 246;
                G = 94;
                B = 59;

                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + twoDigitC, tOffRow + twoDigitR],'64','Font','DejaVuSans-Bold' , 'FontSize',42, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      

            case 128   
                R = 237;
                G = 207;
                B = 114;

                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + threeDigitC, tOffRow + threeDigitR],'128','Font','DejaVuSans-Bold' , 'FontSize',40, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      

            case 256
                R = 236;
                G = 204;
                B = 97;

                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + threeDigitC, tOffRow + threeDigitR],'256','Font','DejaVuSans-Bold' , 'FontSize',40, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      

            case 512
                R = 237;
                G = 200;
                B = 90;

                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + threeDigitC, tOffRow + threeDigitR],'512','Font','DejaVuSans-Bold' , 'FontSize',40, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      

            case 1024
                R = 237;
                G = 197;
                B = 63;

                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + fourDigitC, tOffRow + fourDigitR],'1024','Font','DejaVuSans-Bold' , 'FontSize',36, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      

            case 2048
                R = 237;
                G = 194;
                B = 46;

                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + fourDigitC, tOffRow + fourDigitR],'2048','Font','DejaVuSans-Bold' , 'FontSize',36, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      

            case 4096
                R = 0;
                G = 0;
                B = 0;
    
                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + fourDigitC, tOffRow + fourDigitR],'4096','Font','DejaVuSans-Bold' , 'FontSize',36, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      
            
            case 8192
                R = 0;
                G = 0;
                B = 0;
    
                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + fourDigitC, tOffRow + fourDigitR],'8192','Font','DejaVuSans-Bold' , 'FontSize',36, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      
            
            case 16384
                R = 0;
                G = 0;
                B = 0;
    
                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + fiveDigitC, tOffRow + fiveDigitR],'16384','Font','DejaVuSans-Bold' , 'FontSize',32, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      
            
            case 32768
                R = 0;
                G = 0;
                B = 0;
    
                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + fiveDigitC, tOffRow + fiveDigitR],'32768','Font','DejaVuSans-Bold' , 'FontSize',32, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      
            
            case 65536
                R = 0;
                G = 0;
                B = 0;
    
                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + fiveDigitC, tOffRow + fiveDigitR],'65536','Font','DejaVuSans-Bold' , 'FontSize',32, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      
               
            case 131072
                R = 0;
                G = 0;
                B = 0;

                pixels(rowStart:rowEnd,colStart:colEnd,1) = R;
                pixels(rowStart:rowEnd,colStart:colEnd,2) = G;
                pixels(rowStart:rowEnd,colStart:colEnd,3) = B;
                pixels = insertText(pixels,[tOffCol + sixDigitC, tOffRow + sixDigitR],'131072','Font','DejaVuSans-Bold' , 'FontSize',28, 'TextColor', 'white', 'TextBoxColor', 'white', 'BoxOpacity', 0);                                      
            
        end        
 
    end
end

    % Drawing grid lines after tiles are correctly drawn.
    % General Formula: Line after tile K = ((K*122)+9-3) : ((K*122)+9+4)
	% Example: K=1 (122+9-3):(122+9+4) = 128:135

    % Vertical
    pixels(:,128:135,1) = 187;
    pixels(:,128:135,2) = 173;
    pixels(:,128:135,3) = 160;

    pixels(:,250:257,1) = 187;
    pixels(:,250:257,2) = 173;
    pixels(:,250:257,3) = 160;

    pixels(:,372:379,1) = 187;
    pixels(:,372:379,2) = 173;
    pixels(:,372:379,3) = 160;

    % Horizontal
    pixels(128:135,:,1) = 187;
    pixels(128:135,:,2) = 173;
    pixels(128:135,:,3) = 160;

    pixels(250:257,:,1) = 187;
    pixels(250:257,:,2) = 173;
    pixels(250:257,:,3) = 160;

    pixels(372:379,:,1) = 187;
    pixels(372:379,:,2) = 173;
    pixels(372:379,:,3) = 160;
	
% Read in an image of my computer desktop to save as the background for the overlay.
% Size is 1918 x 1198
% Note: board size is 504*504	
desktop = imread('score_margin.png');

% Static board dimensions- determined from previous geometry.
boardSize = 504;

% Using randi to generate random offset values for board placement on the desktop background.
% These values were chosen to prevent the board from being drawn off the page.
% Introduces variety in the visual outputs.
% These values depend on the image size being approximately similar to the one I've chosen.
topOffset = 80;
leftOffset = 0;

% Copy entire board into desktop target area.
% desktop[start:end, start:end, 1:3] = pixels(1:504,1:504,1:3)
% Using end = start + length - 1 ensures exactly 504px get copied.
% Example: topOffset=42 → rows 42:545 (545-42+1=504 pixels)
desktop(80:height(desktop)-1,1:boardSize,:) = pixels;
% desktop(8:72,8:160,:) = 0;

appName = insertText(desktop,[10,8],'2048','Font','DejaVuSans-Bold' , 'FontSize',36, 'TextColor', 'black', 'TextBoxColor', 'yellow', 'BoxOpacity', 1);                                      
appName = insertShape(appName, "rectangle",[8 8 128 64],'LineWidth',8,'ShapeColor','black');

scoreBrd = insertText(appName,[140,10],'Score: ','Font','DejaVuSans-Bold' , 'FontSize',36, 'TextColor', 'black', 'TextBoxColor', 'white', 'BoxOpacity', 1); 
scoreBrd = insertText(scoreBrd,[278,10],score,'Font','DejaVuSans-Bold' , 'FontSize',36, 'TextColor', 'black', 'TextBoxColor', 'white', 'BoxOpacity', 1); 
% desktop(topOffset:topOffset+boardSize-1, leftOffset:leftOffset+boardSize-1, :) = pixels;

% Now pixels holds the final overlaid image
pixels = scoreBrd;  




% % Save image to the disk as a png image.
% imwrite(pixels,'2048_game.png');
% end

