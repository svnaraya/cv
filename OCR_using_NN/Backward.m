function [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a)
% [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a) computes the gradient
% updates to the deep network parameters and returns them in cell arrays
% 'grad_W' and 'grad_b'. This function takes as input:
%   - 'W' and 'b' the network parameters
%   - 'X' and 'Y' the single input data sample and ground truth output vector,
%     of sizes Nx1 and Cx1 respectively
%   - 'act_h' and 'act_a' the network layer pre and post activations when forward
%     forward propogating the input smaple 'X'

    grad_W = cell(1, length(W));
    grad_b = cell(1, length(W));

    delta = act_a{end} - Y;
    
    for i = 1 : length(W)
        
        grad_b{i} = delta;
        if i == length(W)
            grad_W{i} = act_a{end-1}' * delta;
        elseif i == 1
            grad_W{i} = X' * delta;
            for j = length(W) : -1 : i + 1
                grad_W{i} = grad_W{i} * W{j}' .* SigmoidPrime(act_h{j-1});
                grad_b{i} = grad_b{i} * W{j}' .* SigmoidPrime(act_h{j-1});
            end
        else
            grad_W{i} = act_h{i-1}' * delta;
            for j = length(W): -1: i + 1
                grad_W{i} = grad_W{i} * W{j}' .* SigmoidPrime(act_h{j-1});
                grad_b{i} = grad_b{i} * W{j}' .* SigmoidPrime(act_h{j-1});
            end
        end
        
    end

end

function output = SigmoidPrime(input)
    output = exp(-input) ./ ((ones(size(input)) + exp(-input)) .^ 2);
end