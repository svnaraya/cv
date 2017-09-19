function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup

    % Define the number of correspondences
    N = size(pts1, 1);

    % Normalise the points with the given scale factor
    pts1Normalised = pts1 / M;
    pts2Normalised = pts2 / M;
    
    % Formulate a homogeneous linear equation of the form AF' = 0
    A = [pts1Normalised(:, 1) .* pts2Normalised(:, 1), pts1Normalised(:, 1) .* pts2Normalised(:, 2), pts1Normalised(:, 1), ...
         pts1Normalised(:, 2) .* pts2Normalised(:, 1), pts1Normalised(:, 2) .* pts2Normalised(:, 2), pts1Normalised(:, 2), ...
         pts2Normalised(:, 1), pts2Normalised(:, 2), ones(N, 1)];
     
    % Compute the SVD of Y, and determine the left singular vector corresponding to the smallest singular value
    [~, ~, V] = svd(A);
    F = reshape(V(:, 9), 3, 3)';
    
    % Refine the F matrix
    F = refineF(F, pts1Normalised, pts2Normalised);
    
    % Rescale the fundamental matrix using a T such that Xnorm = T * X
    T = [(1/M), 0, 0; 0, (1/M), 0; 0, 0, 1];
    F = T' * F * T;

end