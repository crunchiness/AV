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
colors = zeros(N_BALLS,1);

FIRST_FRAME = 25;
N_FRAMES = 63;
N_HYP = 100;


trackers = cell(N_BALLS,1);
for i = 1:N_BALLS
    trackers{i} = tracker(N_HYP, N_FRAMES);
end
trajectories = zeros(N_FRAMES,N_BALLS,2);
appeared = zeros(N_BALLS,1);
bg_frame = chromy(imread('set1/00000025.jpg'));
[img_height, img_width, ~] = size(bg_frame);



for i = FIRST_FRAME:FIRST_FRAME + N_FRAMES - 1
    filename = [file_name sprintf('%08d', i) file_format];
    orig_current = imread(filename);
    [centers, radii, bg_frame] = detect_balls(orig_current, bg_frame);
    detected_colors = get_colors(orig_current, centers, radii);
    if i-FIRST_FRAME == 0
        previous = zeros(N_BALLS,2);
        for j = 1:N_BALLS
           previous(j,1) = floor(rand(1) * img_height);
           previous(j,2) = floor(rand(1) * img_width);
        end
    else
        previous = squeeze(trajectories(i-1,:,:));
    end
    if i == 29
        prev_coords_30 = previous;
        colors_30 = colors;
        detected_coords_30 = centers;
        detected_colors_30 = detected_colors;
    end
    [matches, colors, radii] = match_points(previous, colors, centers, detected_colors, radii);
    
    appeared = appeared + matches;
    for m = 1:N_BALLS
        if matches(m) == 0
            detected_x = NaN;
            detected_y = NaN;
        else
            detected_x = centers(matches(m),1);
            detected_y = centers(matches(m),2);
        end
        trajectories(i,m,:) = trackers{m}.process_frame(i-FIRST_FRAME+1, detected_x, detected_y, appeared(m));
    end
    imshow(orig_current);

        
    for k = 1:N_BALLS
        if colors(k) == 1
            color_name = 'yellow';
        elseif colors(k) == 2
            color_name = 'red';
        elseif colors(k) == 3
            color_name = 'white';
        else
            color_name = 'black';
        end
        x = trajectories(i,k,1);
        y = trajectories(i,k,2);
        if ~isnan(x)
            if matches(k) == 0
                radius = 15;
            else
                radius = radii(matches(k));
            end
            if radius == 0 || isnan(radius)
                radius = 15;
            end
            x = uint32(real(x));
            y = uint32(real(y));
            viscircles([x, y], radius, 'LineWidth', 1, 'EdgeColor', color_name, 'DrawBackgroundCircle', false);
            hold on;
            plot(x, y, 'gx');
            text(double(x), double(y), num2str(k))
        end
    end
    
    hold on
    pause(1)
end
