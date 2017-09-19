clear
clc

% Load frames
load('../data/carseq.mat');
frames = im2double(frames);

% Define template rectangle for 1st frame
rect = [60, 117, 146, 152];
rect_wcrt = [60, 117, 146, 152];
I = frames(:, :, 1);
temp = I(rect(2) : rect(4), rect(1) : rect(3));

% Define template dimensions
tempX = rect(3) - rect(1);
tempY = rect(4) - rect(2);

% Frames to display with bounding box
display = [2, 100, 200, 300, 400];

% Iterate through the frames
for i = 1 : size(frames, 3) - 1
    
    % Define frames i and (i + 1)
    It = frames(:, :, i);
    It1 = frames(:, :, i + 1);
    
    % Calculate template location in (i + 1)th frame
    [u, v] = LucasKanadeInverseCompositional(It, It1, rect(i, :));
    
    % Update template rectangle for next iteration
    rect = [rect; round(u), round(v), round(u) + tempX, round(v) + tempY];
    
    % Calculate corrected template location in (i + 1)th frame
    [u, v] = LucasKanadeInverseCompositional(It, It1, rect_wcrt(i, :));
    [u, v] = LucasKanadeInverseCompositional_wcrt(It, It1, temp, [u, v]);
    
    % Update template rectangle with correction
    rect_wcrt = [rect_wcrt; round(u), round(v), round(u) + tempX, round(v) + tempY];
    
    % Display frame if specified
    if any(display == i)
        figure
        imshow(It)
        hold on
        pause(0.05)
        rectangle('Position', [rect(i, 1), rect(i, 2), tempX, tempY], 'LineWidth', 2)
        rectangle('Position', [rect_wcrt(i, 1), rect_wcrt(i, 2), tempX, tempY], 'LineWidth', 2, 'EdgeColor', 'y')
        pause(0.05)
    end
    
end

save('carseqrects-wcrt.mat', 'rect_wcrt');