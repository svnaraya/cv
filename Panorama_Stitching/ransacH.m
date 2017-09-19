function [bestH] = ransacH(matches, locs1, locs2, nIter, tol)
% INPUTS
% locs1 and locs2 - matrices specifying point locations in each of the images
% matches - matrix specifying matches between these two sets of point locations
% nIter - number of iterations to run RANSAC
% tol - tolerance value for considering a point to be an inlier
%
% OUTPUTS
% bestH - homography model with the most inliers found during RANSAC
    
    % Default no. of iterations
    if ~exist('nIter', 'var') || isempty(nIter)
        nIter = 100;
    end

    % Default tolerance
    if ~exist('tol', 'var') || isempty(tol)
        tol = 0.0005;
    end

    bestH = [];
    nInliers = 0;
    
    % No. of samples to consider for initial model
    nSample = 5;
    
    for i = 1:nIter
        
        % Sample random matches and construct a H matrix
        maybeInliers = datasample(matches, nSample, 'replace', false);
        p1 = locs1(maybeInliers(:, 1), 1:2);
        p2 = locs2(maybeInliers(:, 2), 1:2);
        maybeH = computeH(p1', p2');
        
        % Reshape H to a vector
        h = reshape(maybeH', [9, 1]);
        
        % Find the matches that were not used to compute H
        candidates = matches(~ismember(matches, maybeInliers, 'rows'), :);
        p1 = locs1(candidates(:, 1), 1:2);
        p2 = locs2(candidates(:, 2), 1:2);
        
        % Compute matrices to write these points in Ah = 0 form
        X = [-p2(:, 1), -p2(:, 2), -ones(size(p2, 1), 1), zeros(size(p2, 1), 3), p2(:, 1) .* p1(:, 1), p2(:, 2) .* p1(:, 1), p1(:, 1)];
        Y = [zeros(size(p2, 1), 3), -p2(:, 1), -p2(:, 2), -ones(size(p2, 1), 1), p2(:, 1) .* p1(:, 2), p2(:, 2) .* p1(:, 2), p1(:, 2)];
        
        % Find the error of each equation
        errorX = X * h;
        errorY = Y * h;
        
        % Check how many of the errors are under the tolerance, and choose only those points
        alsoInliers = [];
        for j = 1:size(errorX, 1)
            if (errorX(j)^2) + (errorY(j)^2) <= tol
                alsoInliers = [alsoInliers; candidates(j, :)];
            end            
        end
        
        % If there are more inliers with this H than any previous H, recompute H with all of these inliers
        if size(alsoInliers, 1) > nInliers
            p1 = [locs1(maybeInliers(:, 1), 1:2); locs1(alsoInliers(:, 1), 1:2)];
            p2 = [locs2(maybeInliers(:, 2), 1:2); locs2(alsoInliers(:, 2), 1:2)];
            bestH = computeH(p1', p2');
            nInliers = size(alsoInliers, 1);
        end
        
    end

end