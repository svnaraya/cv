function [numGrad_W, numGrad_b, index_W, index_b] = checkGradient(W, b, x, y)

    epsilon = 0.0001;
    nSamples = 10;
    
    numGrad_W = cell(1, length(W));
    numGrad_b = cell(1, length(b));
    
    index_W = cell(1, length(W));
    index_b = cell(1, length(b));

    for i = 1 : length(W)

        W1 = W;
        W2 = W;
        b1 = b;
        b2 = b;
        numGrad_W{i} = zeros(nSamples, 1);
        numGrad_b{i} = zeros(nSamples, 1);
        
        [~, index_W{i}] = datasample(W{i}(:), nSamples, 'Replace', false);
        [~, index_b{i}] = datasample(b{i}(:), nSamples, 'Replace', false);
        
        for j = 1 : length(index_W)
            W1{i}(index_W{i}(j)) = W1{i}(index_W{i}(j)) - epsilon;
            W2{i}(index_W{i}(j)) = W2{i}(index_W{i}(j)) + epsilon;
            b1{i}(index_b{i}(j)) = b1{i}(index_b{i}(j)) - epsilon;
            b2{i}(index_b{i}(j)) = b2{i}(index_b{i}(j)) + epsilon;
            
            [oW1, ~, ~] = Forward(W1, b, x);
            [oW2, ~, ~] = Forward(W2, b, x);
            [ob1, ~, ~] = Forward(W, b1, x);
            [ob2, ~, ~] = Forward(W, b2, x);
            
            numGrad_W{i}(j) = (CrossEntropy(y, oW2) - CrossEntropy(y, oW1)) / (2 * epsilon);
            numGrad_b{i}(j) = (CrossEntropy(y, ob2) - CrossEntropy(y, ob1)) / (2 * epsilon);
        end

    end

end

function loss = CrossEntropy(y, o)
    loss = -sum(y .* log(o));
end