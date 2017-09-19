function M = LucasKanadeAffine(It, It1)

% input - image at time t, image at t+1 
% output - M affine transformation matrix

    % Set warp parameters and define the warp matrix
    p = [zeros(1, 6)];
    M = [1 + p(1), p(3), p(5); p(2), 1 + p(4), p(6)];
    
    % Define size of image
    imSize = size(It1);
    imSizeX = size(It1, 1);
    imSizeY = size(It, 2);
        
    % Evaluate gradient of It
    [dY, dX] = gradient(It);
    dX = dX(:);
    dY = dY(:);
%     delT = [dX, dY];
    delT = [dX, dY, dX, dY, dX, dY];
    
    % Set threshold for stopping iterations
    threshold = 10 ^ -5;
    
    % Define error norm
    norm_p = Inf;
    
    % Define all pixel locations in It by linear indices
    linearIndicesIt = [1 : imSizeX * imSizeY]';
    % Convert linear indices in It to 2D coordinates
    [x, y] = ind2sub(imSize, linearIndicesIt);
    % Form a matrix of the form [x, y, 1]' to warp the points from It's frame to It1's frame
    locs = [x'; y'; ones(1, imSizeX * imSizeY)];
    
    % Compute the Jacobians
%     J = [locs(1, :)', zeros(imSizeX * imSizeY, 1), locs(2, :)', zeros(imSizeX * imSizeY, 1), ones(imSizeX * imSizeY, 1), zeros(imSizeX * imSizeY, 1)];
%     J = cat(3, J, circshift(J, [0, 1]));
%     J = permute(J, [3 2 1]);
    J = [locs(1, :)', locs(1, :)', locs(2, :)', locs(2, :)', ones(imSizeX * imSizeY, 1), ones(imSizeX * imSizeY, 1)];
    
    while norm_p > threshold
        
        % Warp the pixels from It's frame to It1's frame
        warpedLocs = M * locs;
        
        % Check which warped pixels still lie within the boundaries of It1
        lowerBounds = [1; 1];
        upperBounds = [imSizeX; imSizeY];
        inBounds = warpedLocs >= lowerBounds & warpedLocs <= upperBounds;
        inBounds = inBounds(1, :) & inBounds(2, :);
        inBounds = find(inBounds);
        
        % Store interpolated values
        It1Val = interp2(It1, warpedLocs(2, inBounds), warpedLocs(1, inBounds));
        It1Val = It1Val';
        
        % Valid gradient for this iteration
        validDelT = delT(inBounds, :);
        
        % Valid Jacobians for this iteration
%         validJ = J(:, :, inBounds);
        validJ = J(inBounds, :);
        
        % Evaluate the steepest descent
%         SD = [];
%         for i = 1:length(inBounds)
%             SD = [SD; validDelT(i, :) * validJ(:, :, i)];
%         end
        SD = validDelT .* validJ;
        
        % Evaluate the Hessian
        H = SD' * SD;
        
        % Find the error in pixel values
        error = It(inBounds') - It1Val;
        
        % Find the change in parameters
        delta_p = - H \ (SD' * error);
        
        % Calculate the norm of delta_p
        norm_p = delta_p' * delta_p;
        
        % Find inverse of change in warp parameters
        delta_p_inv = (1/(((1 + delta_p(1)) * (1 + delta_p(4))) - (delta_p(2) * delta_p(3)))) * ...
                        [- delta_p(1) - (delta_p(1) * delta_p(4)) + (delta_p(2) * delta_p(3));...
                         - delta_p(2);...
                         - delta_p(3);...
                         - delta_p(4) - (delta_p(1) * delta_p(4)) + (delta_p(2) * delta_p(3));...
                         - delta_p(5) - (delta_p(4) * delta_p(5)) + (delta_p(3) * delta_p(6));...
                         - delta_p(6) - (delta_p(1) * delta_p(6)) + (delta_p(2) * delta_p(5))];
                     
        % Update the warp matrix parameters
        p = [p(1) + delta_p_inv(1) + (p(1) * delta_p_inv(1)) + (p(3) * delta_p_inv(2));...
             p(2) + delta_p_inv(2) + (p(2) * delta_p_inv(1)) + (p(4) * delta_p_inv(2));...
             p(3) + delta_p_inv(3) + (p(1) * delta_p_inv(3)) + (p(3) * delta_p_inv(4));...
             p(4) + delta_p_inv(4) + (p(2) * delta_p_inv(3)) + (p(4) * delta_p_inv(4));...
             p(5) + delta_p_inv(5) + (p(1) * delta_p_inv(5)) + (p(3) * delta_p_inv(6));...
             p(6) + delta_p_inv(6) + (p(2) * delta_p_inv(5)) + (p(4) * delta_p_inv(6))];
        
        % Update the transformation matrix
        M = [1 + p(1), p(3), p(5); p(2), 1 + p(4), p(6)];
        
    end

end