function [u, v] = LucasKanadeInverseCompositional_wcrt(It, It1, temp, rect)

% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [u,v] in the x- and y-directions.

    % Set warp parameters and define the warp matrix
    p = [rect(2), rect(1)];
    W = [1, 0, p(1)-1; 0, 1, p(2)-1];
    
    % Define template size
    tempSizeX = size(temp, 1);
    tempSizeY = size(temp, 2);
    
    % Evaluate gradient of the template, and compute delT
    [dY, dX] = gradient(temp);
    dX = dX(:);
    dY = dY(:);
    delT = [dX dY];
    
    % Evaluate the Jacobian at p = 0
    J = eye(2);
    
    % Evaluate the steepest descent
    S = delT * J;
    
    % Calculate the inverse of the Hessian
    H_inv = inv(S' * S);
    
    % Set threshold for stopping iterations
    threshold = 10 ^ -2;
    
    % Define error norm
    norm_p = Inf;
    
    % Define all pixel locations in template rectangle by linear indices
    linearIndicesTemp = [1 : tempSizeX * tempSizeY]';
    % Convert linear indices in template to 2D coordinates
    [x, y] = ind2sub(size(temp), linearIndicesTemp);
    % Form a matrix of the form [x, y, 1]' to warp the points from the template's frame to It1's frame
    locs = [x'; y'; ones(1, tempSizeX * tempSizeY)];
    
    while norm_p > threshold
        
        % Warp the pixels from the template's frame to It1's frame
        warpedLocs = W * locs;
        % Store interpolated values
        It1Val = interp2(It1, warpedLocs(2, :), warpedLocs(1, :));
        It1Val = It1Val';
        
        % Find the error in pixel values
        error = temp(linearIndicesTemp) - It1Val;
        % Find the change in parameters
        delta_p = H_inv * S' * error;
        
        % Calculate the norm of delta_p
        norm_p = delta_p' * delta_p;
        
        % Update the parameters and the transformation matrix
        p = p + delta_p';
        W = [1, 0, p(1) - 1; 0, 1, p(2) - 1];
        
    end
    
    u = p(2);
    v = p(1);
    
end