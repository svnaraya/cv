function [conf] = evaluateRecognitionSystem()
% Evaluates the recognition system for all test-images and returns the confusion matrix

	load('vision.mat');
	load('../data/traintest.mat');
    
	% Initialize the confusion matrix with zeroes
    conf = zeros(8);
    
    % For each test image, calculate the histogram using the spatial pyramid, and find the closest match from the training data
    for i = 1:size(test_imagenames)
        load(strcat('../data/', strrep(test_imagenames{i}, '.jpg', '.mat')));
        h = getImageFeaturesSPM(3, wordMap, size(dictionary, 2));
%         h = getImageFeatures(wordMap, size(dictionary, 2));
        [~, index] = max(distanceToSet(h, train_features));
%         [~, index] = min(chiSquareDistance(h, train_features));
        conf(test_labels(i), train_labels(index)) = conf(test_labels(i), train_labels(index)) + 1;
    end
    
end