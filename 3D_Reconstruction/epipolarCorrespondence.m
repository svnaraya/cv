function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q2.6 - Todo:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q2_6.mat
%
%           Explain your methods and optimization in your writeup

    % Find the epipolar line matrix
    x = [x1; y1; 1];
    eLine = F * x;
    
    % Define window size and extract patch from im1
    w = 14; 
    % TOOD: Check if patch is within image boundaries
    patchIm1 = im1 (y1 - w : y1 + w, x1 - w : x1 + w);
%     figure
%     imshow(patchIm1)
    
    % Traverse epipolar line about a window around (x1, y1) to find best (x2, y2)
    search = 30;
    smallestD = Inf;
    
    for j = y1 - search : 1 : y1 + search
        i = round (- ((eLine (2) / eLine (1)) * j) - (eLine (3) / eLine (1)));
        % TODO: Check if patch is within image boundaries
        patchIm2 = im2 (j - w : j + w, i - w : i + w);
%         figure
%         imshow(patchIm2)
        d = abs (double (patchIm1) - double (patchIm2));
        d = sum (sum (d .* d));
        if d < smallestD
            smallestD = d;
            x2 = i;
            y2 = j;
            bestPatchIm2 = patchIm2;
        end
    end

end

