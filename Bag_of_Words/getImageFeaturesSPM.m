function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% Compute histogram of visual words using SPM method
% Inputs:
%   layerNum: Number of layers (L+1)
%   wordMap: WordMap matrix of size (h, w)
%   dictionarySize: the number of visual words, dictionary size
% Output:
%   h: histogram of visual words of size {dictionarySize * (4^layerNum - 1)/3} (l1-normalized, ie. sum(h(:)) == 1)

    % Calculate histograms of the final layer in the spatial pyramid
    [h_last, h_norm_last] = recursiveHistogram(layerNum - 1, wordMap, dictionarySize);
    
    % Sum up the histograms of the individual regions from the final layer
    % to get the histograms of regions in each of the preceding layers
    h = [];
    for i = 1:layerNum-1
        h2 = [];
        for j = 1:2.^(2*i-2)
            % Index the histograms from the last layer appropriately, and
            % normalize
            h1 = sum(h_last(:, ((j-1) * size(h_last, 2) / 2.^(2*i-2)) + 1:(j * size(h_last, 2) / 2.^(2*i-2))), 2);
            h1 = h1/sum(h1);
            % Weight the histograms appropriately, based on the layer
            if i == 1
                h1 = (2.^(1-layerNum))*h1;
            else
                h1 = (2.^(i-layerNum-1))*h1;
            end
            % Record all hisotgrams of a given layer
            h2 = [h2; h1];
        end
        % Add to the variable containing histograms from all layers
        h = [h; h2];
    end
    
    % Add the histograms of the last layer at the end
    h = [h; h_norm_last];
end