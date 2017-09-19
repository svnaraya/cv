function buildRecognitionSystem()
% Creates vision.mat. Generates training features for all of the training images.

	load('dictionary.mat');
	load('../data/traintest.mat');

    train_features = [];
    layerNum = 3;

    % Calculate histograms using spatial pyramid for each training image's word map, and store it in the variable 'train_features'
    for i = 1:size(train_imagenames)
        train_imagenames{i} = strrep(train_imagenames{i}, '.jpg', '.mat');
        load(strcat('../data/', train_imagenames{i}));
        train_features = [train_features getImageFeaturesSPM(layerNum, wordMap, size(dictionary, 2))];
%         train_features = [train_features getImageFeatures(wordMap, size(dictionary, 2))];
    end

	save('vision.mat', 'filterBank', 'dictionary', 'train_features', 'train_labels');

end