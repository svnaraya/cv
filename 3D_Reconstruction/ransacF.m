function [ F ] = ransacF( pts1, pts2, M )
% ransacF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.X - Extra Credit:
%     Implement RANSAC
%     Generate a matrix F from some '../data/some_corresp_noisy.mat'
%          - using sevenpoint
%          - using ransac

%     In your writeup, describe your algorithm, how you determined which
%     points are inliers, and any other optimizations you made

    threshold = 0.01;
    bestError = Inf;
    bestF = zeros(3);

    for i = 1 : 50
        
        p1 = pts1;
        p2 = pts2;
        
        [~, maybeInliers] = datasample (pts1, 8, 'Replace', false);
        F = eightpoint (p1 (maybeInliers, :), p2 (maybeInliers, :), M);
        
        p1 (maybeInliers, :) = [];
        p2 (maybeInliers, :) = [];
        
        alsoInliers = zeros (1, length (p1));
        for j = 1 : length (p1)
            l = F * [p1(j, :)'; 1];
            if abs((l(1) * p2(j, 1)) + (l(2) * p2(j, 2)) + l(3)) < threshold
                alsoInliers (j) = j;
            end
        end
        
%         [~, maybeInliers] = datasample (pts1, 7, 'Replace', false);
%         F = sevenpoint (p1 (maybeInliers, :), p2 (maybeInliers, :), M);
%         
%         p1 (maybeInliers, :) = [];
%         p2 (maybeInliers, :) = [];
%         
%         inliers = zeros (1, length (p1));
%         count = 0;
%         
%         for k = 1 : length(F)
%             for j = 1 : length (p1)
%                 l = F{k} * [p1(j, :)'; 1];
%                 if abs((l(1) * p2(j, 1)) + (l(2) * p2(j, 2)) + l(3)) < threshold
%                     inliers (j) = j;
%                 end
%             end
%             if length(find(inliers)) > count
%                 alsoInliers = inliers;
%                 count = length(find(inliers));
%                 index = k;
%             end
%         end
        
%         F = F{index};

        alsoInliers = alsoInliers (alsoInliers ~= 0);
        
        if length(alsoInliers) > (0.65 * length (pts1))
            
            points1 = [pts1(maybeInliers, :); p1(alsoInliers, :)];
            points2 = [pts2(maybeInliers, :); p2(alsoInliers, :)];
            betterF = eightpoint (points1, points2, M);
            
            thisError = 0;
            for j = 1 : length (points1)
                l = F * [points1(j, :)'; 1];
                thisError = thisError + abs((l(1) * points2(j, 1)) + (l(2) * points2(j, 2)) + l(3));
            end
            
            if thisError < bestError
                bestError = thisError;
                bestF = betterF;
            end
            
        end
        
    end
    
    F = bestF;

end

