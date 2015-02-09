function [ radius, center ] = get_ball( boundary )
%GET_BALLS Summary of this function goes here
%   Detailed explanation goes here

    w = max(boundary(:,2)) - min(boundary(:,2));
    h = max(boundary(:,1)) - min(boundary(:,1));

    radius = (w+h) / 4;
    center_reverse = mean(boundary);
    center = [center_reverse(2), center_reverse(1)];

end

