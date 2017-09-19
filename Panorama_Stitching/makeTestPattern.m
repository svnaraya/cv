function [compareA, compareB] = makeTestPattern(patchWidth, nbits) 
%%Creates Test Pattern for BRIEF
%
% Run this routine for the given parameters patchWidth = 9 and n = 256 and
% save the results in testPattern.mat.
%
% INPUTS
% patchWidth - the width of the image patch (usually 9)
% nbits      - the number of tests n in the BRIEF descriptor
%
% OUTPUTS
% compareA and compareB - LINEAR indices into the patchWidth x patchWidth image 
%                         patch and are each nbits x 1 vectors. 

    % Create permutation of all pairs 
    [a, b] = meshgrid([1:patchWidth*patchWidth], [1:patchWidth*patchWidth]);
    c = cat(2, a, b);
    c = reshape(c, [], 2);
    
    % Select nbits pairs
    locs = datasample(c, nbits, 'Replace', false);
    compareA = locs(:, 1);
    compareB = locs(:, 2);

end