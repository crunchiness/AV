load balls_loc.mat

num_balls = size(new_balls,2);
present = zeros(1, num_balls);
limits  = zeros(1, num_balls);
nextid  = ones(1, num_balls);
ball_name = {'white 1', 'white 2', 'pink 1', 'pink 2', 'orange 1', 'orange 2', 'orange 3', 'orange 4', 'orange 5', 'orange 6'};
file_name='./set1/';
file_format='.jpg';
N_FRAMES = 63;

bg_frame = chromy(imread('set1/00000025.jpg'));
[img_height, img_width, ~] = size(bg_frame);

for i = 25:25 - 1 + N_FRAMES
    filename = [file_name sprintf('%08d', i) file_format];
    orig_current = imread(filename);
    [centers, radii, bg_frame] = detect_balls(orig_current, bg_frame);
    imshow(orig_current);
    for j = 1:size(centers,1)
        viscircles(centers(j,:), radii(j), 'LineWidth', 1, 'EdgeColor', 'green', 'DrawBackgroundCircle', false);
        plot(centers(j,1), centers(j,2), 'gx');
    end
    hold on
    pause(0.5)
end
