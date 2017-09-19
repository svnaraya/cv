function [lines, bw] = findLetters(im)
% [lines, BW] = findLetters(im) processes the input RGB image and returns a cell
% array 'lines' of located characters in the image, as well as a binary
% representation of the input image. The cell array 'lines' should contain one
% matrix entry for each line of text that appears in the image. Each matrix entry
% should have size Lx4, where L represents the number of letters in that line.
% Each row of the matrix should contain 4 numbers [x1, y1, x2, y2] representing
% the top-left and bottom-right position of each box. The boxes in one line should
% be sorted by x1 value.

%     clear
%     clc
%     close all
    
    threshold = 120;

%     im = imread('../images/01_list.jpg');
%     im = imread('../images/02_letters.jpg');
%     im = imread('../images/03_haiku.jpg');
%     im = imread('../images/04_deep.jpg');

    filter = fspecial('average', [5 5]);
    
    filteredIm = imfilter(im, filter, 'symmetric');
    grayIm = rgb2gray(filteredIm);
    binIm = grayIm < threshold;
    
%     im_montage = im2double(im);
%     filteredIm_montage = im2double(filteredIm);
%     grayIm_montage = cat(3, im2double(grayIm), im2double(grayIm), im2double(grayIm));
%     binIm_montage = cat(3, mat2gray(binIm), mat2gray(binIm), mat2gray(binIm));
    
%     montage(cat(4, im_montage, filteredIm_montage, grayIm_montage, binIm_montage));

    cc = bwconncomp(binIm);
    
%     imshow(im)
%     hold on
    
    boxSize = zeros(length(cc.PixelIdxList), 1);
    boxWidth = zeros(length(cc.PixelIdxList), 1);
    boxHeight = zeros(length(cc.PixelIdxList), 1);
    minX = zeros(length(cc.PixelIdxList), 1);
    minY = zeros(length(cc.PixelIdxList), 1);
    maxX = zeros(length(cc.PixelIdxList), 1);
    maxY = zeros(length(cc.PixelIdxList), 1);
    
    for i = 1 : length(cc.PixelIdxList)
        idx = cc.PixelIdxList{i};
        [x, y] = ind2sub(size(binIm), idx);
        minX(i) = min(x);
        minY(i) = min(y);
        maxX(i) = max(x);
        maxY(i) = max(y);
        boxSize(i) = (maxX(i) - minX(i)) * (maxY(i) - minY(i));
        boxHeight(i) = maxX(i) - minX(i);
        boxWidth(i) = maxY(i) - minY(i);
    end
    
    avgBoxSize = sum(boxSize) / length(boxSize);
    avgBoxWidth = sum(boxWidth) / length(boxWidth);
    avgBoxHeight = sum(boxHeight) / length(boxHeight);
    numBoxes = 0;
    centroidY = [];
    ids = [];
    for i = 1 : length(cc.PixelIdxList)
        if boxSize(i)/avgBoxSize > 0.45
%             rectangle('Position', [minY(i) - 10, minX(i) - 10, maxY(i) - minY(i) + 20, maxX(i) - minX(i) + 20], 'EdgeColor', 'r', 'LineWidth', 1)
            centroidY = [centroidY; (minX(i) + maxX(i)) / 2];
            numBoxes = numBoxes + 1;
            ids = [ids; i];
        end
    end
    
    minX = minX(ids);
    minY = minY(ids);
    maxX = maxX(ids);
    maxY = maxY(ids);
    
    [centroidY, idSort] = sort(centroidY);
    minX = minX(idSort);
    minY = minY(idSort);
    maxX = maxX(idSort);
    maxY = maxY(idSort);
    
    d = -Inf;
    numLines = 0;
    count = 0;
    lettersPerLine = [];
    for i = 1 : length(centroidY)
        if centroidY(i) - d > avgBoxHeight
            numLines = numLines + 1;
            lettersPerLine = [lettersPerLine; count];
            count = 0;
        end
        d = centroidY(i);
        count = count + 1;
    end
    lettersPerLine = [lettersPerLine; count];
    cumLettersPerLine = cumsum(lettersPerLine);
    
    lines = cell(1, numLines);
    
    for i = 1 : length(lines)
        lines{i} = zeros(lettersPerLine(i+1), 4);
        batchMinX = minX(cumLettersPerLine(i) + 1 : cumLettersPerLine(i+1));
        batchMinY = minY(cumLettersPerLine(i) + 1 : cumLettersPerLine(i+1));
        batchMaxX = maxX(cumLettersPerLine(i) + 1 : cumLettersPerLine(i+1));
        batchMaxY = maxY(cumLettersPerLine(i) + 1 : cumLettersPerLine(i+1));
        [batchMinY, idSort] = sort(batchMinY);
        batchMinX = batchMinX(idSort);
        batchMaxX = batchMaxX(idSort);
        batchMaxY = batchMaxY(idSort);
        for j = 1 : lettersPerLine(i+1)
            lines{i}(j, :) = [batchMinX(j), batchMinY(j), batchMaxX(j), batchMaxY(j)];
        end
    end
    
    bw = grayIm > threshold;
    
end
