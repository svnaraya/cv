function [ P, error ] = triangulate( C1, p1, C2, p2 )
% triangulate:
%       C1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       C2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

% Q2.4 - Todo:
%       Implement a triangulation algorithm to compute the 3d locations

    P = zeros(3, length(p1));

    for i = 1 : length(p1)
        % Define 2D camera points as skew symmetric matrices x and y to perform cross products p1 x C1.P and p2 x C2.P to solve for P
        % We only care about the first 2 rows (hence 3rd row is ignored)
        x = [0, -1, p1(i, 2); 1, 0, -p1(i, 1)];
        y = [0, -1, p2(i, 2); 1, 0, -p2(i, 1)];
        % A is equivalent to (p1 x C1) and (p2 x C2)
        A = [x * C1; y * C2];
        % Find SVD of A and take the right singular vector corresponding to the smallest singular value for least squares solution of P
        [~, ~, V] = svd(A);
        P(:, i) = V(1 : end - 1, end) / V(end, end);
    end
    
    P1 = C1 * [P; ones(1, size(P, 2))];
    P2 = C2 * [P; ones(1, size(P, 2))];
    
    error =  sum (sum ((p1' - (P1(1:2, :) ./ P1(3, :))) .^ 2) + sum ((p2' - (P2(1:2, :) ./ P2(3, :))) .^ 2));
    
    P = P';

end