function [W, b] = Train(W, b, train_data, train_label, learning_rate)
% [W, b] = Train(W, b, train_data, train_label, learning_rate) trains the network
% for one epoch on the input training data 'train_data' and 'train_label'. This
% function should returned the updated network parameters 'W' and 'b' after
% performing backprop on every data sample.


% This loop template simply prints the loop status in a non-verbose way.
% Feel free to use it or discard it

    order = randperm(size(train_data, 1));
    train_data = train_data(order, :);
    train_label = train_label(order, :);
    
%     gradError_W = 0;
%     gradError_b = 0;

    fprintf('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n')
    for i = 1:size(train_data, 1)

        [~, act_h, act_a] = Forward(W, b, train_data(i, :));
        [grad_W, grad_b] = Backward(W, b, train_data(i, :), train_label(i, :), act_h, act_a);
        
%         % This block of code is to cross check gradients from the backpropogation function with numerical estimation
%         [numGrad_W, numGrad_b, index_W, index_b] = checkGradient(W, b, train_data(i, :), train_label(i, :));
%                 
%         for j = 1 : size(index_W)
%             gradError_W = gradError_W + sum(abs(grad_W{j}(index_W{j}) - numGrad_W{j}'));
%             gradError_b = gradError_b + sum(abs(grad_b{j}(index_b{j}) - numGrad_b{j}'));
%         end
%         % END
        
        [W, b] = UpdateParameters(W, b, grad_W, grad_b, learning_rate);

        if mod(i, 100) == 0
            fprintf('\b\b\b\b\b\b\b\b\b\b\b\b')
            fprintf('Done %.2f %%', i/size(train_data,1)*100)
        end
    end
    %fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b')
%     fprintf('\nAvg error in gradient of weights = %.4f', gradError_W/size(train_data, 1));
%     fprintf('\nAvg error in gradient of biases = %.4f', gradError_b/size(train_data, 1));
    fprintf('\n')

end
