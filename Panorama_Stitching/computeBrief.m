function [locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, ...
                                        levels, compareA, compareB)
%%Compute BRIEF feature
% INPUTS
% im      - a grayscale image with values from 0 to 1
% locsDoG - locsDoG are the keypoint locations returned by the DoG detector
% levels  - Gaussian scale levels that were given in Section1
% compareA and compareB - linear indices into the patchWidth x patchWidth image 
%                         patch and are each nbits x 1 vectors
%
% OUTPUTS
% locs - an m x 3 vector, where the first two columns are the image coordinates 
%		 of keypoints and the third column is the pyramid level of the keypoints
% desc - an m x n bits matrix of stacked BRIEF descriptors. m is the number of 
%        valid descriptors in the image and will vary
    
    patchWidth = 9;
    locs = [];
    desc = [];
    
    % Iterate through the key points
    for i = 1:size(locsDoG, 1)
        
        % Check if a patch of required size can be sampled around each key point
        if locsDoG(i, 1) - floor(patchWidth/2) >= 1 && locsDoG(i, 1) + floor(patchWidth/2) <= size(im, 1) && locsDoG(i, 2) - floor(patchWidth/2) >= 1 && locsDoG(i, 2) + floor(patchWidth/2) <= size(im, 2)
        
            locs = [locs; [locsDoG(i, 2) locsDoG(i, 1) locsDoG(i, 3)]];
            
            % Extract patch at key point location from smoothed image(GaussianPyramid)at the level the key point was found
            patch = GaussianPyramid(locsDoG(i,1)-floor(patchWidth/2):locsDoG(i,1)+floor(patchWidth/2), locsDoG(i,2)-floor(patchWidth/2):locsDoG(i,2)+floor(patchWidth/2), locsDoG(i,3)+2);
            
            % Encode descriptor for the patch
            desc = [desc; (patch(compareA) < patch(compareB))'];

        end
        
    end

end