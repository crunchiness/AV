function [ dist_weights ] = get_dist_probs( centers_prev, radii_prev, x_current )
%GET_DIST_PROBS Summary of this function goes here
%   Detailed explanation goes here
    coords = [x_current(1), x_current(2)];
    N_balls = size(centers_prev,1);
   
    dist_weights = zeros(N_balls,1);
    sdistances = zeros(N_balls);
    total_sdistance = 0;
    for i = 1:N_balls
        center = [centers_prev(i,2), centers_prev(i,1)];
        sdistances(i) = norm(coords - center)^2;
        total_sdistance = total_sdistance + 1/sdistances(i);
    end
    for i = 1:N_balls
        if sdistances(i) == 0
            dist_weights(i) = 1;
        else
            dist_weights(i) = (1/sdistances(i))/total_sdistance;
        end
    end
end

