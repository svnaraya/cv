function locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, ...
                        PrincipalCurvature, th_contrast, th_r)
%%Detecting Extrema
% INPUTS
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
% DoG Levels  - The levels of the pyramid where the blur at each level is
%               outputs
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix contains the
%                      curvature ratio R
% th_contrast - remove any point that is a local extremum but does not have a
%               DoG response magnitude above this threshold
% th_r        - remove any edge-like points that have too large a principal
%               curvature ratio
%
% OUTPUTS
% locsDoG - N x 3 matrix where the DoG pyramid achieves a local extrema in both
%           scale and space, and also satisfies the two thresholds.
    
    LocExtSp = LocalExtremaInSpace(DoGPyramid);
    LocExtSc = LocalExtremaInScale(DoGPyramid);
    Cth = DoGPyramid > th_contrast;
    PCth = PrincipalCurvature < th_r;
    
    locExtrema = LocExtSp & LocExtSc & Cth & PCth;
    
    locMaxIDX = find(locExtrema);
    x = [];
    y = [];
    z = [];
    [x, y, z] = ind2sub([size(DoGPyramid, 1) size(DoGPyramid, 2) size(DoGPyramid, 3)], locMaxIDX);
    locsDoG = [x y DoGLevels(z)'];
       
end