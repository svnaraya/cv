close all
clear
clc

% imPath = '../images/01_list.jpg';
% imPath = '../images/02_letters.jpg';
% imPath = '../images/03_haiku.jpg';
imPath = '../images/04_deep.jpg';

[text] = extractImageText(imPath);

for i = 1 : length(text)
    disp(strjoin(text{i}))
    fprintf('\n')
end