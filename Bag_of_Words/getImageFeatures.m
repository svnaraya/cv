function [h] = getImageFeatures(wordMap, dictionarySize)
% Compute histogram of visual words
% Inputs:
% 	wordMap: WordMap matrix of size (h, w)
% 	dictionarySize: the number of visual words, dictionary size
% Output:
%   h: vector of histogram of visual words of size dictionarySize (l1-normalized, ie. sum(h(:)) == 1)

	% Vectorize the word map
    wordMap = reshape(wordMap, 1, size(wordMap, 1)*size(wordMap, 2));
    
    % Calculate the histogram, with bins from 1 to dictionary size, and
    % normalize the values
    h = hist(wordMap, [1:dictionarySize]);
    h = h/sum(h);
    h = h';
    
	assert(numel(h) == dictionarySize);
end