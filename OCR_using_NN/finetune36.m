clear
clc

num_epoch = 5;
classes = 36;
layers = [32*32, 800, classes];
learning_rate = 0.01;

load('../data/nist26_model_60iters.mat')

load('../data/nist36_train.mat', 'train_data', 'train_labels')
load('../data/nist36_test.mat', 'test_data', 'test_labels')
load('../data/nist36_valid.mat', 'valid_data', 'valid_labels')

for i = 1 : length(W)
    W{i} = W{i}';
    b{i} = b{i}';
end

W_temp = normrnd(0, 1, layers(end - 1), layers(end) - size(W{end}, 2)) / sqrt(layers(1));
b_temp = zeros(1, layers(end) - size(W{end}, 2));

W{end} = [W{end}, W_temp];
b{end} = [b{end}, b_temp];

train_acc = zeros(1, num_epoch);
train_loss = zeros(1, num_epoch);
valid_acc = zeros(1, num_epoch);
valid_loss = zeros(1, num_epoch);

for j = 1:num_epoch
    [W, b] = Train(W, b, train_data, train_labels, learning_rate);

    [train_acc(j), train_loss(j)] = ComputeAccuracyAndLoss(W, b, train_data, train_labels);
    [valid_acc(j), valid_loss(j)] = ComputeAccuracyAndLoss(W, b, valid_data, valid_labels);

    fprintf('Epoch %d - accuracy: %.5f, %.5f \t loss: %.5f, %.5f \n', j, train_acc(j), valid_acc(j), train_loss(j), valid_loss(j))
end

figure
plot(train_acc * 100, 'ro-')
hold on
plot(valid_acc * 100, 'bo-')
xlabel('No. of epochs')
ylabel('Accuracy of prediction (%)')
legend('Training data', 'Validation data', 'Location', 'northwest')

figure
plot(train_loss, 'ro-')
hold on
plot(valid_loss, 'bo-')
xlabel('No. of epochs')
ylabel('Loss in prediction')
legend('Training data', 'Validation data')

save('nist36_model.mat', 'W', 'b')