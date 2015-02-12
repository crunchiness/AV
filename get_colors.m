function [ colors ] = get_colors(orig_current, centers, radii)
%GET_COLORS Summary of this function goes here
%   Detailed explanation goes here

% colors 1=yellow; 2=pink; 3=white;
yellow = [190, 109, 30];
pink = [181, 55, 103];
white = [150, 150, 150];
% y(1,1,:) = [190, 109, 30];
% p(1,1,:) = [181, 55, 103];
% w(1,1,:) = [150, 150, 150];
% y1 = chromy(y);
% p1 = chromy(p);
% w1 = chromy(w);
% y2 = [y1(1,1,1), y1(1,1,2), y1(1,1,3)];
% p2 = [p1(1,1,1), p1(1,1,2), p1(1,1,3)];
% w2 = [w1(1,1,1), w1(1,1,2), w1(1,1,3)];
% chromy_colors = [y2; p2; w2];
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
%     color1(1,1,:) = color;
%     color2 = chromy(color1);
%     color3 = [color2(1,1,1),color2(1,1,2),color2(1,1,3)];
%     d1 = norm(color3-chromy_colors(1,:));
%     d2 = norm(color3-chromy_colors(2,:));
%     d3 = norm(color3-chromy_colors(3,:));
    
    d1 = norm(norm_color-norm_colors(1,:));
    d2 = norm(norm_color-norm_colors(2,:));
    d3 = norm(norm_color-norm_colors(3,:));
    [~,p] = min([d1, d2, d3]);
    colors(i) = p;
%     if a && b && c && d && e
%         colors(i) = 2;
%     end
end

% pic(:,:,1) = uint8((ones(h,w,'double')-(0.5*double(C))).*double(r));
% pic(:,:,2) = uint8((ones(h,w,'double')-(0.5*double(C))).*double(g));
% pic(:,:,3) = uint8((ones(h,w,'double')-(0.5*double(C))).*double(pink));
% 
% 
% imshow(pic);
% hold on;
% centers = uint32(centers);
% for i = 1:n
%     if colors(i) == 1
%         plot(centers(i,1), centers(i,2), 'yx');
%     elseif colors(i) == 2
%         plot(centers(i,1), centers(i,2), 'rx');
%     elseif colors(i) == 3
%         plot(centers(i,1), centers(i,2), 'wx');
%     end
% end

end