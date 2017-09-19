% Script to test BRIEF under rotations

% Read image
img1 = im2double(rgb2gray(imread('../data/model_chickenbroth.jpg')));
% Find keypoints
[locs1, desc1] = briefLite(img1);

matchesCount = [];
correctMatchesCount = [];
threshold = 6;

% Rotate image in steps of 10 degrees
for i = 0:10:360
    
    img2 = imrotate(img1, i);
    % Find keypoints of rotated image
    [locs2, desc2] = briefLite(img2);
    % Find matches between keypoints
    matches = briefMatch(desc1, desc2);
    % Record the number of matches found
    matchesCount = [matchesCount; repmat(i, [size(matches, 1), 1])];
    
    p1 = locs1(matches(:, 1), 1:2);
    p2 = locs2(matches(:, 2), 1:2);
    p1 = padarray(p1, [0 1], 1, 'post');
    p2 = padarray(p2, [0 1], 1, 'post');
    p1 = p1';
    p2 = p2';
    origin = repmat([floor(size(img1, 2)/2); floor(size(img1, 1)/2); 0], [1, size(p1, 2)]);
    % Translate origin of unrotated image to the centre of the image
    p1Centred = p1 - origin;
    
    % Define the rotation matrix
    R = [cosd(i) -sind(i) 0; sind(i) cosd(i) 0; 0 0 1];
    
    % Rotate matched keypoints from unrotated image, and translate the origin back to the corner
    p1to2 = round((R * p1Centred)) + origin;
    
    % Measure distance of rotated matched keypoints from corresponding keypoints in the rotated image
    dist = p2 - p1to2;
    dist = sqrt(dist(1, :) .^ 2 + dist(2, :) .^ 2);
    
    % Classify a match as correct if the distance is within the threshold
    correctMatchesCount = [correctMatchesCount; repmat(i, [sum(dist < threshold), 1])];
    
end

% Define histogram bins
bins = [0:10:360];

% Generate histograms
figure(1);
hist(matchesCount, bins);
xlabel('Angle of rotation (in degrees)');
ylabel('Number of matches');
figure(2);
hist(correctMatchesCount, bins);
xlabel('Angle of rotation (in degrees)');
ylabel('Number of correct matches');