% load balls_loc.mat
% N_BALLS = size(new_balls,2);

N_BALLS = 10;
present = zeros(1, N_BALLS);
limits  = zeros(1, N_BALLS);
nextid  = ones(1, N_BALLS);
ball_name = {'white 1', 'white 2', 'pink 1', 'pink 2', 'orange 1', 'orange 2', 'orange 3', 'orange 4', 'orange 5', 'orange 6'};
file_name='./set1/';
file_format='.jpg';

FIRST_FRAME = 25;
N_FRAMES = 63;

bg_frame = chromy(imread('set1/00000025.jpg'));
[img_height, img_width, ~] = size(bg_frame);



for i = FIRST_FRAME:FIRST_FRAME + N_FRAMES - 1
    filename = [file_name sprintf('%08d', i) file_format];
    orig_current = imread(filename);
    [centers, radii, bg_frame] = detect_balls(orig_current, bg_frame);
    get_coulors(orig_current, centers, radii);
    for m = 1:N_BALLS
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
        
    for k = 1:size(centers,1)
        viscircles(centers(k,:), radii(k), 'LineWidth', 1, 'EdgeColor', 'green', 'DrawBackgroundCircle', false);
        plot(centers(k,1), centers(k,2), 'gx');
    end
    hold on
    pause(0.1)
    %TODO update centers rsdfaf
    centers_prev = centers;
    radii_prev = radii;
end
