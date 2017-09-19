function [output, act_h, act_a] = Forward(W, b, X)
% [OUT, act_h, act_a] = Forward(W, b, X) performs forward propogation on the
% input data 'X' uisng the network defined by weights and biases 'W' and 'b'
% (as generated by InitializeNetwork(..)).
% This function should return the final softmax output layer activations in OUT,
% as well as the hidden layer pre activations in 'act_h', and the hidden layer post
% activations in 'act_a'.
    
    act_h = cell(1, length(W));
    act_a = cell(1, length(W));
    activated{1} = X;
    activated = [activated, act_a];
    
    for i = 1:length(W)
        act_h{i} = (activated{i} * W{i}) + b{i};
        if i == length(W)
            act_a{i} = Softmax(act_h{i});
        else
            act_a{i} = Sigmoid(act_h{i});
        end
        activated{i+1} = act_a{i};
    end

    output = act_a{end};
    
end

function output = Sigmoid(input)
    output = ones(size(input)) ./ (ones(size(input)) + exp(-input));
end

function output = Softmax(input)
    output = exp(input) / sum(exp(input));
end