function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup

    % Define the number of correspondences
    N = size(pts1, 1);

    % Normalise the points with the given scale factor
    pts1Normalised = pts1 / M;
    pts2Normalised = pts2 / M;
    
    % Formulate a homogeneous linear equation of the form AF' = 0
    A = [pts1Normalised(:, 1) .* pts2Normalised(:, 1), pts1Normalised(:, 1) .* pts2Normalised(:, 2), pts1Normalised(:, 1), ...
         pts1Normalised(:, 2) .* pts2Normalised(:, 1), pts1Normalised(:, 2) .* pts2Normalised(:, 2), pts1Normalised(:, 2), ...
         pts2Normalised(:, 1), pts2Normalised(:, 2), ones(N, 1)];
     
    % Compute the SVD of Y, and determine the right singular vectors corresponding to the two smallest singular values
    [~, ~, V] = svd(A);
    F1 = reshape(V(:, 8), 3, 3)';
    F2 = reshape(V(:, 9), 3, 3)';
%     [U1, S1, V1] = svd(F1);
%     S1(end, end) = 0;
%     F1 = U1 * S1 * V1';
%     [U2, S2, V2] = svd(F2);
%     S2(end, end) = 0;
%     F2 = U2 * S2 * V2';
    
    % Parametrise and solve
    syms lambda
    solution = vpasolve(det(F1 + lambda * F2));
    solution = double(solution);
    
    % Determine the fundamental matrix as a linear combination of the right singular vectors
    if isreal(solution)
        F = cell(size(solution));
        for i = 1 : length(solution)
            F{i} = F1 + solution(i) * F2;
        end
    else
        for i = 1 : length(solution)
            if isreal(solution(i))
                realSol = solution(i)
            end
        end
        F = cell(1);
        F{1} = F1 + realSol * F2;
    end
    
    % Refine the F matrices
%     for i = 1 : length(F)
%         F{i} = refineF(cell2mat(F(i)), pts1, pts2);
%     end
    
    % Rescale the fundamental matrices using a T such that Xnorm = T * X
    T = [(1/M), 0, 0; 0, (1/M), 0; 0, 0, 1];
    for i = 1 : length(F)
        F{i} = T' * cell2mat(F(i)) * T;
    end

end

