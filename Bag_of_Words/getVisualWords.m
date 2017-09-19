function [wordMap] = getVisualWords(img, filterBank, dictionary)
% Compute visual words mapping for the given image using the dictionary of visual words.

% Inputs:
% 	img: Input RGB image of dimension (h, w, 3)
% 	filterBank: a cell array of N filters
% Output:
%   wordMap: WordMap matrix of same size as the input image (h, w)

    % Check if image is double, and convert to double if it isn't
    if ~strcmp(class(img), 'double')
        img = im2double(img);
    end
    
    dictionary = dictionary';
    
    % Calculate the filter response of the image
    filterResponses = extractFilterResponses(img, filterBank);
    fSize1 = size(filterResponses, 1);
    fSize2 = size(filterResponses, 2);
    
    % Vectorize the filter response
    filterResponses = reshape(filterResponses, size(filterResponses, 1)*size(filterResponses, 2), size(filterResponses,3));
    
    % Find the index of the element in 'dictionary' that has smallest
    % Euclidian distance, for each pixel in the filter response
    [D, I] = pdist2(dictionary, filterResponses, 'euclidean', 'Smallest', 1);

    wordMap = reshape(I, fSize1, fSize2);
end
