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
    foremm3(:,:,1) = ones([480,640],'double') - bwperim(foremm);
    foremm3(:,:,2) = foremm3(:,:,1);
    foremm3(:,:,3) = foremm3(:,:,1);
    orig_current = uint8(double(orig_current) .* foremm3);
    Imback = (Imback + 0.1*(current_frame .* bg_pixels2) + 0.1*(Imback .* foremm2)) / 1.1;
    [centers_lame, radii_lame] = imfindcircles(foremm, [6 300]);
    [centers, radii] = find_overlap(centers_lame, radii_lame, 1.9);
    imshow(orig_current);
    for j = 1:size(centers,1)
        viscircles(centers(j,:), radii(j), 'LineWidth', 1, 'EdgeColor', 'green', 'DrawBackgroundCircle', false);
        plot(centers(j,1), centers(j,2), 'gx');
    end
%     stuff = bwboundaries(foremm,'noholes');
%     %clc
%     imshow(orig_current);
%     boundaries = bwboundaries(foremm);
%     for j = 1:length(boundaries)
%         [radius, center] = get_ball(boundaries{j});
%         viscircles(center, radius, 'LineWidth', 1, 'EdgeColor', 'green', 'DrawBackgroundCircle', false);
%         plot(center(1), center(2), 'gx');
%     end
    hold on
    pause(0.5)
end
