% Q2.7 - Todo:
% Integrating everything together.
% Loads necessary files from ../data/ and visualizes 3D reconstruction
% using scatter3

close all
clear
clc

load ('../data/templeCoords.mat')
load ('../data/intrinsics.mat')
load ('q2_1.mat', 'F')
load ('q2_5.mat', 'M2')

img1 = imread('../data/im1.png');
img2 = imread('../data/im2.png');

x2 = zeros (size (x1));
y2 = zeros (size (y1));

for i = 1 : length (x1)
    [x2(i), y2(i)] = epipolarCorrespondence (img1, img2, F, x1(i), y1(i));
end

E = essentialMatrix (F, K1, K2);

M1 = eye (3, 4);
M2s = camera2 (E);

for i = 1 : 4
    [P, error] = triangulate (K1 * M1, [x1, y1], K2 * M2s (:, :, i), [x2, y2]);
    if all (P (:, 3) > 0)
        M2 = M2s (:, :, i);
        break;
    end
end

save ('q2_7.mat', 'F', 'M1', 'M2')

scatter3 (P (:, 1), P (:, 2), P (:, 3))