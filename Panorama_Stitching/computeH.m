function H2to1 = computeH(p1, p2)
% INPUTS:
% p1 and p2 - Each are size (2 x N) matrices of corresponding (x, y)'  
%             coordinates between two images
%
% OUTPUTS:
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear 
%         equation

    p1 = p1';
    p2 = p2';
    
    % Construct the A matrix (for the form Ah = 0)
    A = [-p2(:, 1), -p2(:, 2), -ones(size(p2, 1), 1), zeros(size(p2, 1), 3), p2(:, 1) .* p1(:, 1), p2(:, 2) .* p1(:, 1), p1(:, 1);...
         zeros(size(p2, 1), 3), -p2(:, 1), -p2(:, 2), -ones(size(p2, 1), 1), p2(:, 1) .* p1(:, 2), p2(:, 2) .* p1(:, 2), p1(:, 2)];
    
    % Find the singular value decomposition of A
    [u, s, v] = svd(A);
    
    % The last column of v contains the h that minimizes ||Ah||
    H2to1 = reshape(v(:, size(v, 1)), [3, 3]);
    H2to1 = H2to1';
    
end