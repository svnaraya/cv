function [filterBank, dictionary] = getFilterBankAndDictionary(imPaths)
% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image (or relative path wrt the working directory.
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.
    
    % Create a filter bank
    filterBank  = createFilterBank();
    
    % Initialize alpha (no. of random pixels to sample from each image),
    % and K (no. of clusters to classify pixels into)
    alpha = 100;
    K = 200;
    
    % Sample alpha pixels from the filter responses of each image
    randomFilterResponses = [];
    
    for i = 1:size(imPaths, 1)
        
        im = im2double(imread(imPaths{i}));
        if length(size(im)) < 3
            im = cat(3, im, im, im);
        end
        filterResponses = extractFilterResponses(im, filterBank);
        filterResponses = reshape(filterResponses, size(filterResponses, 1)*size(filterResponses, 2), size(filterResponses,3));
        randomFilterResponses = cat(1, randomFilterResponses, datasample(filterResponses, alpha));
        
        progress = 100 * i / size(imPaths, 1)
    end
    
    disp('100% filtering complete')
    
    % Cluster alpha*T pixels into K clusters, and store the locations of the
    % means
    [~, dictionary] = kmeans(randomFilterResponses, K, 'EmptyAction', 'drop');
    dictionary = dictionary';
    
    disp('Clustering complete')
end
