close all
clear
clc

% Load frames
load('../data/aerialseq.mat');
frames = im2double(frames);

% Frames to display motion tracking
display = [30, 60, 90, 120];

% Iterate the frames
for i = 1:length(display)
    
    % Define frames It and It1
    It = frames(:, :, display(i));
    It1 = frames(:, :, display(i) + 1);
    
    % Calculate the mask for this frame
    mask = SubtractDominantMotion(It, It1);
    
    % Display frame if specified
    figure
    imshow(imfuse(It1, cat(3, zeros(size(mask)), mask, mask), 'blend'))
    
end