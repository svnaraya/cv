% Q2.5 - Todo:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       3. Save the correct M2, p1, p2, R and P to q2_5.mat

clear
close all
clc

load ('../data/some_corresp.mat');
load ('../data/intrinsics.mat');
load ('q2_1.mat', 'F')

E = essentialMatrix (F, K1, K2);

M1 = eye (3, 4);
M2s = camera2 (E);

for i = 1 : 4
    [P, error] = triangulate (K1 * M1, pts1, K2 * M2s (:, :, i), pts2);
    if all (P (:, 3) > 0)
        M2 = M2s (:, :, i);
        break;
    end
end

p1 = pts1;
p2 = pts2;
save ('q2_5.mat', 'M2', 'p1', 'p2', 'P');