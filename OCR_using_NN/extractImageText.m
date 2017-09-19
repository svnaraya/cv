function [text] = extractImageText(fname)
% [text] = extractImageText(fname) loads the image specified by the path 'fname'
% and returns the next contained in the image as a string.
    
    im = imread(fname);
    
    imshow(im)
    
    [lines, bw] = findLetters(im);
    bw = imerode(bw, strel('disk', 5));
    
    testSet = cell(length(lines), 1);
    
    for i = 1 : length(lines)
        testSet{i} = zeros(size(lines{i}, 1), 32*32);
        for j = 1 : size(lines{i}, 1)
            testIm = bw(lines{i}(j, 1) - 5 : lines{i}(j, 3) + 5, lines{i}(j, 2) - 5 : lines{i}(j, 4) + 5);
            
            [xSize, ySize] = size(testIm);
            if xSize > ySize
                pad = floor(0.1 * xSize);
                testIm = padarray(testIm, [pad, pad + floor((xSize - ySize)/2)], 1);
            else
                pad = floor(0.1 * ySize);
                testIm = padarray(testIm, [pad + floor((ySize - xSize)/2), pad], 1);
            end
%             testIm = reinforceBlack(testIm);
            testIm = imresize(testIm, [32 32]);
            testSet{i}(j, :) = reshape(testIm, [1, 32*32]);
        end
    end
    
    text = cell(length(lines), 1);
    
    load 'nist36_model.mat'
    labels = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'];
    
    for i = 1 : length(testSet)
        text{i} = strings(1, size(testSet{i}, 1));
        for j = 1 : size(testSet{i}, 1)
            [output, ~, ~] = Forward(W, b, testSet{i}(j, :));
            [~, class] = max(output);
            text{i}(j) = labels(class);
        end
    end

end