function [ matches ] = match_points( previous, detected, detected_colors )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%TODO
s = size(previous,1);
matches = zeros(s,1);
for i=1:size(previous)
    [d,p] = min((detected(:,1)-x).^2 + (detected(:,2)-y).^2);
    if find(p==matches)
    elseif d < 100
        matches(i) = p;
    end
end
