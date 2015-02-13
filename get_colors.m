function [ colors ] = get_colors(orig_current, centers, radii)
%GET_COLORS Summary of this function goes here
%   Detailed explanation goes here

% colors 1=yellow; 2=pink; 3=white;
yellow = [190, 109, 30];
pink = [181, 55, 103];
white = [150, 150, 150];

norm_colors = [yellow/sum(yellow); pink/sum(pink); white/sum(white)];

[h, w, ~] = size(orig_current);
n = size(radii,1);
colors = zeros(n,1);

for i = 1:n
    % mean of 0.3*radius area
    [rr, cc] = meshgrid(1:w,1:h);
    C = double(sqrt((rr-centers(i,1)).^2+(cc-centers(i,2)).^2) <= 0.3*radii(i));
    r = orig_current(:,:,1);
    g = orig_current(:,:,2);
    pink = orig_current(:,:,3);
    meanR = mean(r(logical(C)));
    meanG = mean(g(logical(C)));
    meanB = mean(pink(logical(C)));
    
    color = [meanR, meanG, meanB];
    norm_color = color/sum(color);
    
    d1 = norm(norm_color-norm_colors(1,:));
    d2 = norm(norm_color-norm_colors(2,:));
    d3 = norm(norm_color-norm_colors(3,:));
    [~,p] = min([d1, d2, d3]);
    colors(i) = p;

end



end