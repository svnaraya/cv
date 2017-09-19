function [filterResponses] = extractFilterResponses(img, filterBank)
% Extract filter responses for the given image.
% Inputs: 
%   img:                a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W x H x N*3 matrix of filter responses


    % Check if image is greyscale, and convert to RGB if it is
    if length(size(img)) < 3
        img = cat(3, img, img, img);
    end
    
    % Convert image from RGB to Lab scheme
    [L, a, b] = RGB2Lab(img(:, :, 1), img(:, :, 2), img(:, :, 3));
    imgLab = cat(3, L, a, b);
    
    % Convolve the image with each filte rin the filter bank, and store the
    % responses in the form of a W x H x N*3 matrix
    filterResponses = [];

    for i = 1:size(filterBank)
        filterResponses = cat(3, filterResponses, imfilter(imgLab, filterBank{i}, 'replicate'));
    end
end
