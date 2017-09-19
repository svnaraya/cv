function [accuracy, loss] = ComputeAccuracyAndLoss(W, b, data, labels)
% [accuracy, loss] = ComputeAccuracyAndLoss(W, b, X, Y) computes the networks
% classification accuracy and cross entropy loss with respect to the data samples
% and ground truth labels provided in 'data' and labels'. The function should return
% the overall accuracy and the average cross-entropy loss.

    outputs = Classify(W, b, data);
    
    [~, class] = max(outputs, [], 2);
    [~, labelClass] = max(labels, [], 2);
    
    accuracy = sum(class == labelClass) / length(labelClass);
    
    loss = -sum(log(max(outputs .* labels, [], 2))) / size(outputs, 1);

end