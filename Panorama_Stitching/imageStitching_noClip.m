function [panoImg] = imageStitching_noClip(img1, img2, H)
    
    % Define a matrix with the corners of the image to be warped
    corners = [1 size(img2, 2) 1 size(img2, 2); 1 1 size(img2, 1) size(img2, 1); 1 1 1 1];
    % Warp the corners of the image
    warpedCorners = H * corners;
    % Normalize the output to get the absolute pixel values
    alpha = repmat(warpedCorners(3, :), [3 1]);
    warpedCorners = warpedCorners ./ alpha;
    
    % Find the maximum x-size of the 3rd frame, and by how much img1 has to be translated in it
    if min(warpedCorners(1, :)) < 1
        xSize = ceil(max([warpedCorners(1, :) size(img1, 2)])) - floor(min(warpedCorners(1, :)));
        xTranslate = floor(min(warpedCorners(1, :)));
    else
        xSize = ceil(max([warpedCorners(1, :) size(img1, 2)]));
        xTranslate = 0;
    end

    % Find the maximum y-size of the 3rd frame, and by how much img1 has to be translated in it
    if min(warpedCorners(2, :)) < 1
        ySize = ceil(max([warpedCorners(2, :) size(img1, 1)])) - floor(min(warpedCorners(2, :)));
        yTranslate = floor(min(warpedCorners(2, :)));
    else
        ySize = ceil(max([warpedCorners(2, :) size(img1, 1)]));
        yTranslate = 0;
    end

    % Compute the matrix for warping img1 and img2 into the 3rd frame
    M = [1 0 abs(xTranslate); 0 1 abs(yTranslate); 0 0 1];

    % Warp the images
    warpedImg1 = warpH(img1, M, [ySize xSize]);
    warpedImg2 = warpH(img2, M * H, [ySize xSize]);

    % Combine the 2 images
    panoImg = max(warpedImg1, warpedImg2);
    
    % Write image to drive, save H matrix
    save('../results/q6_1.mat', 'H');
    imwrite(panoImg, '../results/q6_2_pan.jpg');
    
end