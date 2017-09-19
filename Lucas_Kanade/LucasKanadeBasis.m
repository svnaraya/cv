function [u,v] = LucasKanadeBasis(It, It1, rect, bases)

% input - image at time t, image at t+1, rectangle (top left, bot right
% coordinates), bases 
% output - movement vector, [u,v] in the x- and y-directions.

    % Define no. of bases
    numBases = size(bases, 3);

    % Set warp parameters, bases weights, and define the warp matrix
    p = [rect(2) - 1, rect(1) - 1];
    w = [ones(1, numBases) / numBases];
    W = [1, 0, p(1); 0, 1, p(2)];
    
    % Extract template from image, and define its size
    temp = It(rect(2):rect(4), rect(1):rect(3));
    tempSizeX = size(temp, 1);
    tempSizeY = size(temp, 2);
    
    % Define image size
    imSizeX = size(It, 1);
    imSizeY = size(It, 2);
    
    % Vectorize bases
    basesVector = reshape(bases, tempSizeX * tempSizeY, numBases);
    
    % Evaluate gradient of the template, and compute delT
    [dYtemp, dXtemp] = gradient(temp);
    dXtemp = dXtemp(:);
    dYtemp = dYtemp(:);
    delT = [dXtemp, dYtemp];
    
    % Evauate gradient of the bases
    [dYbases, dXbases] = gradient(bases);
    dXbases = reshape(dXbases, tempSizeX * tempSizeY, numBases);
    dYbases = reshape(dYbases, tempSizeX * tempSizeY, numBases);
    delA = cat(3, dXbases, dYbases);
    delA = permute(delA, [1, 3, 2]);
    
    % Evaluate the Jacobian at p = 0
    J = eye(2);
    
    % Set threshold for stopping iterations
    threshold = 10^-2;
    
    % Define error norm
    norm_q = Inf;
    
    % Define pixel coordinates of image frame
    linearIndicesTemp = [1 : tempSizeX * tempSizeY]';
    [x, y] = ind2sub(size(temp), linearIndicesTemp);
    locs = [x'; y'; ones(1, tempSizeX * tempSizeY)];
    
    while norm_q > threshold
        
        % Warp the pixels from It1's frame to It's frame
        warpedLocs = W * locs;
        % Store interpolated values
        It1Val = interp2(It1, warpedLocs(2, :), warpedLocs(1, :))';
        
        % Make a weights matrix of the same size as basesVector (for easy element-wise multiplication)
        weightsVector = repmat(w, [tempSizeX * tempSizeY, 1]);
        
        % Find the error in pixel values
        error = temp(linearIndicesTemp) - It1Val + sum(weightsVector .* basesVector, 2);
        
        % Make another weights matrix of the same size as delA (for easy element-wise multiplication)
        weightsVector_delA = permute(w, [1, 3, 2]);
        weightsVector_delA = repmat(weightsVector_delA, [tempSizeX * tempSizeY, 2, 1]);
        
        % Calculate the steepest descent
        grad = delT + sum(weightsVector_delA .* delA, 3);
        SD = [grad * J, basesVector];
        
        % Compute the inverse Hessian
        H_inv = inv(SD' * SD);
        
        % Find the change in parameters
        delta_q = H_inv * SD' * error;
        
        % Calculate the norm of delta_p
        norm_q = delta_q' * delta_q;
        
        % Update the parameters and the transformation matrix
        p = p + delta_q(1:2)';
        w = w - delta_q(3:end)';
        W = [1, 0, p(1) - 1; 0, 1, p(2) - 1];
        
    end
    
    u = p(2);
    v = p(1);

end