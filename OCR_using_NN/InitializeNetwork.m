function [W, b] = InitializeNetwork(layers)
% InitializeNetwork([INPUT, HIDDEN, OUTPUT]) initializes the weights and biases
% for a fully connected neural network with input data size INPUT, output data
% size OUTPUT, and HIDDEN number of hidden units.
% It should return the cell arrays 'W' and 'b' which contain the randomly
% initialized weights and biases for this neural network.

    % Initialize weight matrices of size [no. of neurons in preceding layer x no. of neurons in succeeding layer]
    % with random weights from normal distribution of mean=0, stddev=1, 
    % and normalized by the square root of number of neurons in the input layer
    W = cell(1, length(layers) - 1);
    for i = 1 : length(layers) - 1
        W{i} = normrnd(0, 1, layers(i), layers(i+1)) / sqrt(layers(i));
    end
    
    % Initialize biases initially to zero
    b = cell(1, length(layers) - 1);
    for i = 1 : length(layers) - 1
        b{i} = zeros(1, layers(i+1));
    end

end
