clear
clc

% Load bases
load('../data/sylvbases.mat')
bases = im2double(bases);

% Load frames
load('../data/sylvseq.mat')
frames = im2double(frames);

% Define template rectangle for 1st frame
rect = [102, 62, 156, 108];

% Define template dimensions
tempX = rect(3) - rect(1);
tempY = rect(4) - rect(2);

% Frames to display with bounding box
display = [2, 200, 300, 350, 400];

% Iterate through the frames
for i = 1 : size(frames, 3) - 1
    
    % Define frames i and (i + 1)
    It = frames(:, :, i);
    It1 = frames(:, :, i + 1);
    
    % Calculate template location in (i + 1)th frame
    [u, v] = LucasKanadeBasis(It, It1, rect(i, :), bases);
    
    % Update template rectangle for next iteration
    rect = [rect; round(u), round(v), round(u) + tempX, round(v) + tempY];
    
    % Display frame if specified
    if any(display == i)
        figure
        imshow(It)
        hold on
        pause(0.05)
        rectangle('Position', [rect(i, 1), rect(i, 2), tempX, tempY], 'LineWidth', 2, 'EdgeColor', 'y')
        pause(0.05)
    end
    
    save('sylvseqrects.mat', 'rect');
    
end