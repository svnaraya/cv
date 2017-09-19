clear
clc

% Load frames
load('../data/usseq.mat');
frames = im2double(frames);

% Define template rectangle for 1st frame
rect = [255, 105, 310, 170];

% Define template dimensions
tempX = rect(3) - rect(1);
tempY = rect(4) - rect(2);

% Frames to display with bounding box
display = [5, 25, 50, 75, 99];

% Iterate through the frames
for i = 1 : size(frames, 3) - 1
    
    % Define frames i and (i + 1)
    It = frames(:, :, i);
    It1 = frames(:, :, i + 1);
    
    % Calculate template location in (i + 1)th frame
    [u, v] = LucasKanadeInverseCompositional(It, It1, rect(i, :));
    
    % Update template rectangle for next iteration
    rect = [rect; round(u), round(v), round(u) + tempX, round(v) + tempY];
    
    % Display frame if specified
    if any(display == i)
        figure
        imshow(It)
        hold on
        pause(0.05)
        rectangle('Position', [rect(i, 1), rect(i, 2), tempX, tempY], 'LineWidth', 2)
        pause(0.05)
    end
    
end

save('usseqrects.mat', 'rect');