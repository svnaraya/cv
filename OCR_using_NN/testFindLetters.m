clear
clc

imPath = '../images/01_list.jpg';
% imPath = '../images/02_letters.jpg';
% imPath = '../images/03_haiku.jpg';
% imPath = '../images/04_deep.jpg';

im = imread(imPath);

[lines, bw] = findLetters(im);

imshow(im);
hold on;

for i = 1 : length(lines)
    for j = 1 : size(lines{i}, 1)
        rectangle('Position', [lines{i}(j, 2) - 10, lines{i}(j, 1) - 10, lines{i}(j, 4) - lines{i}(j, 2) + 20, lines{i}(j, 3) - lines{i}(j, 1) + 20], 'EdgeColor', 'r', 'LineWidth', 1)
    end
end