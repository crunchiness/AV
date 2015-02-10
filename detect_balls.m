function [ centers, radii, updated_bg_frame ] = detect_balls( frame, bg_frame )
%DETECT_BALLS Summary of this function goes here
%   Detailed explanation goes here
    current_frame = chromy(frame);
    fore = current_frame(:,:,3) ./ bg_frame(:,:,3) > 1.15 ...
         | current_frame(:,:,3) ./ bg_frame(:,:,3) < 0.8 ...
         | abs(current_frame(:,:,1) - bg_frame(:,:,1)) > 0.07 ...
         | abs(current_frame(:,:,2) - bg_frame(:,:,2)) > 0.07 ...
         | double(ones([480,640])) - current_frame(:,:,1) - current_frame(:,:,2) - (double(ones([480,640])) - bg_frame(:,:,1) - bg_frame(:,:,2)) > 0.07;
    foremm = bwmorph(fore, 'erode', 3);
    foremm = double(bwareaopen(foremm, 10));
    foremm = bwmorph(foremm, 'dilate', 3);
    
    bg_pixels = ones([480,640], 'double') - double(foremm);
    bg_pixels2(:,:,1) = bg_pixels;
    bg_pixels2(:,:,2) = bg_pixels;
    bg_pixels2(:,:,3) = bg_pixels;
    foremm2(:,:,1) = double(foremm);
    foremm2(:,:,2) = double(foremm);
    foremm2(:,:,3) = double(foremm);
    updated_bg_frame = (bg_frame + 0.1*(current_frame .* bg_pixels2) + 0.1*(bg_frame .* foremm2)) / 1.1;
    [centers_lame, radii_lame] = imfindcircles(foremm, [6 300]);
    [centers, radii] = find_overlap(centers_lame, radii_lame, 1.9);
end