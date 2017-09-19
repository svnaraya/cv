function mask = SubtractDominantMotion(image1, image2)

% input - image1 and image2 form the input image pair
% output - mask is a binary image of the same size

    % Find the matrix that warps image1 to match image2
    M = LucasKanadeAffine(image1, image2);
    
    % Warp image1 to match image2
    image1_warped = warpH(image1, [M;, 0, 0, 1], size(image2));
    
    % Find the difference in pixels between image2 and image1_warped
    diff = image2 - image1_warped;
    
    % Classify the moving pixels based on threshold
    mask = diff > 0.125;
    
    % Improve the mask
    mask = imdilate(mask, strel('disk', 8));
    mask = imerode(mask, strel('disk', 8));
    mask = (mask - bwareaopen(mask, 250)) & bwareaopen(mask, 10);

end