function [locs, desc] = briefLite(im)
% INPUTS
% im - gray image with values between 0 and 1
%
% OUTPUTS
% locs - an m x 3 vector, where the first two columns are the image coordinates 
% 		 of keypoints and the third column is the pyramid level of the keypoints
% desc - an m x n bits matrix of stacked BRIEF descriptors. 
%		 m is the number of valid descriptors in the image and will vary
% 		 n is the number of bits for the BRIEF descriptor

    % Convert RGB image to grayscale, uint8 to double
    if length(size(im)) > 2
        im = rgb2gray(im);
    end
    im = im2double(im);

    % Set parameters
    sigma0 = 1;
    k = sqrt(2);
    levels = [-1:4];
    th_contrast = 0.03;
    th_r = 12;

    % Calculate the key point locations
    [locsDoG, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r);
    
    % Load the test pattern for the descriptor
    load('testPattern.mat')
    
    % Calculate the encoded descriptors for all valid key points in the image
    [locs, desc] = computeBrief(im, GaussianPyramid, locsDoG, k, levels, compareA, compareB);

end