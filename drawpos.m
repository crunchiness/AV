% load balls_loc.mat
% N_BALLS = size(new_balls,2);

N_BALLS = 10;
present = zeros(1, N_BALLS);
limits  = zeros(1, N_BALLS);
nextid  = ones(1, N_BALLS);
ball_name = {'white 1', 'white 2', 'pink 1', 'pink 2', 'orange 1', 'orange 2', 'orange 3', 'orange 4', 'orange 5', 'orange 6'};
file_name='./set1/';
file_format='.jpg';
previous = [];

FIRST_FRAME = 25;
N_FRAMES = 63;
N_HYP = 100;

trackers = cell(N_BALLS,1);
for i = 1:N_BALLS
    trackers{i} = tracker(N_HYP, N_FRAMES);
end
trajectories = zeros(N_FRAMES,N_BALLS,2);
bg_frame = chromy(imread('set1/00000025.jpg'));
[img_height, img_width, ~] = size(bg_frame);



for i = FIRST_FRAME:FIRST_FRAME + N_FRAMES - 1
    filename = [file_name sprintf('%08d', i) file_format];
    orig_current = imread(filename);
    [centers, radii, bg_frame] = detect_balls(orig_current, bg_frame);
    colors = get_colors(orig_current, centers, radii);
    if i == 1
        previous = [];
    else
        previous = trajectories(i-1,:,:);
    end
    matches = match_points(previous, centers, colors);
    for m = 1:N_BALLS
        if matches(m) == 0
            detected_x = NaN;
            detected_y = NaN;
        else
            detected_x = centers(matches(m),1);
            detected_y = centers(matches(m),2);
        end
        trajectories(m,:) = trackers{m}.process_frame(i, detected_x, detected_y);
    end
    dist_weights = get_dist_probs(centers_prev, radii_prev, x_current);
    imshow(orig_current);
    for c = -0.99*radius: radius/10 : 0.99*radius
        r = sqrt(radius^2-c^2);
        %      plot(x(top,i,1)+c,x(top,i,2)+r+1,'b.')
        %      plot(x(top,i,1)+c,x(top,i,2)+r,'y.')
        plot(x{m}(top,i,1)+c,x{m}(top,i,2)+r,'r.')
        plot(x{m}(top,i,1)+c,x{m}(top,i,2)-r,'r.')
        %      plot(x(top,i,1)+c,x(top,i,2)-r,'y.')
        %      plot(x(top,i,1)+c,x(top,i,2)-r-1,'b.')
    end
        
    for k = 1:N_BALLS
        viscircles(trajectories(i,k,:), radii(k), 'LineWidth', 1, 'EdgeColor', 'green', 'DrawBackgroundCircle', false);
        plot(trajectories(i,k,1), trajectories(i,k,2), 'gx');
    end
    hold on
    pause(0.1)
    %TODO update centers rsdfaf
    centers_prev = centers;
    radii_prev = radii;
end
