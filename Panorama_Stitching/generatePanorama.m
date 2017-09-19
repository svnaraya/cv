function img3 = generatePanorama(img1, img2)

    % Find the locations of keypoints
    [locs1, desc1] = briefLite(img1);
    [locs2, desc2] = briefLite(img2);

    % Find matches between keypoints
    matches = briefMatch(desc1, desc2);
    
    % Find the best homography from the matches
    H = ransacH(matches, locs1, locs2);
    
    % Generate the panorama
%     img3 = imageStitching(img1, img2, H);
    img3 = imageStitching_noClip(img1, img2, H);
    
    % Save the image
    imwrite(img3, '../results/q6_3.jpg');

end