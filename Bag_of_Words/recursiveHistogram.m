function [h, h_norm] = recursiveHistogram(L, wordMap, dictionarySize)
% Compute the histograms of the last layer in the spatial pyramid
% Inputs:
%   L - No. of layers in the pyramid (0 when there is no pyramid)
%   wordMap - The word map of an image
%   dictionarySize - Size of the dictionary (No. of clusters formed by k-means)
% Outputs:
%   h - The histograms of each individual region in the last layer, in the form of a dictionarySize x 2^(2*L) matrix
%   h_norm - The histograms of each individual region weighted appropriately and normalized, in the form of a dictionarySize*(2^(2*L)) x 1 vector
% Summary:
%   At each iteration of the recursion, the word map is divided into 4 regions and passed to the same function with a decremented L. 
%   The order maintained is column-wise, i.e. top-left, bottom-left, top-right, then bottom-right. 
%   This way, the histograms of each region in all preceding layers are easily calculated by summing the columns of matrix 'h' in groups of 2^(2*(L-i+1)).
%   When L = 0, the function returns the histogram of the word map. 
    
    h = [];
    h_norm = [];
    
    % If the value of L is 0, return the raw histogram and the weighted normalized histogram of the word map
    if L == 0
        wordMap = reshape(wordMap, 1, size(wordMap, 1)*size(wordMap, 2));
        h = hist(wordMap, [1:dictionarySize]);        
        h = h';
        h_norm = (2.^-1)*h/sum(h);
        
    % If the value of L is not 0, divide the word map into 4 regions and call the function again with each region separately, with a decremented L
    else
        [h1, h_norm1] = recursiveHistogram(L-1, wordMap(1:floor(size(wordMap, 1)/2), 1:floor(size(wordMap, 2)/2)), dictionarySize);
        h = [h h1];
        h_norm = [h_norm; h_norm1];
        [h1, h_norm1] = recursiveHistogram(L-1, wordMap(floor(size(wordMap, 1)/2)+1:size(wordMap, 1), 1:floor(size(wordMap, 2)/2)), dictionarySize);
        h = [h h1];
        h_norm = [h_norm; h_norm1];        
        [h1, h_norm1] = recursiveHistogram(L-1, wordMap(1:floor(size(wordMap, 1)/2), floor(size(wordMap, 2)/2)+1:size(wordMap, 2)), dictionarySize);
        h = [h h1];
        h_norm = [h_norm; h_norm1];        
        [h1, h_norm1] = recursiveHistogram(L-1, wordMap(floor(size(wordMap, 1)/2)+1:size(wordMap, 1), floor(size(wordMap, 2)/2)+1:size(wordMap, 2)), dictionarySize);
        h = [h h1];
        h_norm = [h_norm; h_norm1];
    end

end