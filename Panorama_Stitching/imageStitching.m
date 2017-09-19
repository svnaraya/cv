function [panoImg] = imageStitching(img1, img2, H)
%
% INPUT
% Warps img2 into img1 reference frame using the provided warpH() function
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear
%         equation
%
% OUTPUT
% Blends img1 and warped img2 and outputs the panorama image

    % Define frame size
    xSize = size(img1, 2) + round(size(img2, 2)*3/4);
    ySize = size(img1, 1);
    
    % Warp the images
    warpedImg1 = warpH(img1, eye(3), [ySize xSize]);
    warpedImg2 = warpH(img2, H, [ySize xSize]);
    
    % Combine the 2 images
    panoImg = max(warpedImg1, warpedImg2);
    
    % Write image to drive, save H matrix
    save('../results/q6_1.mat', 'H');
    imwrite(panoImg, '../results/q6_1.jpg');

end