load balls_loc.mat

num_balls = size(new_balls,2);
present = zeros(1, num_balls);
limits  = zeros(1, num_balls);
nextid  = ones(1, num_balls);
ball_name = {'white 1', 'white 2', 'pink 1', 'pink 2', 'orange 1', 'orange 2', 'orange 3', 'orange 4', 'orange 5', 'orange 6'};
file_name='./set1/';
file_format='.jpg';

Imback = chromy(imread('set1/00000025.jpg'));

for i = 25:87
    filename = [file_name sprintf('%08d', i) file_format];
    orig_current = imread(filename);
    current_frame = chromy(orig_current);
    fore = current_frame(:,:,3) ./ Imback(:,:,3) > 1.15 ...
         | current_frame(:,:,3) ./ Imback(:,:,3) < 0.8 ...
         | abs(current_frame(:,:,1) - Imback(:,:,1)) > 0.07 ...
         | abs(current_frame(:,:,2) - Imback(:,:,2)) > 0.07 ...
         | double(ones([480,640])) - current_frame(:,:,1) - current_frame(:,:,2) - (double(ones([480,640])) - Imback(:,:,1) - Imback(:,:,2)) > 0.07;
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
%   imcontour
%   bwboundaries
    foremm3(:,:,1) = ones([480,640],'double') - bwperim(foremm);
    foremm3(:,:,2) = foremm3(:,:,1);
    foremm3(:,:,3) = foremm3(:,:,1);
    orig_current = uint8(double(orig_current) .* foremm3);
    Imback = (Imback + 0.1*(current_frame .* bg_pixels2) + 0.1*(Imback .* foremm2)) / 1.1;
    
    
    
     stuff = bwboundaries(foremm,'noholes');
    
    
    
    
    
    clc
    imshow(orig_current);
    hold on
    pause(0.5)
end

