function [ chrome_image ] = chromy( image )
% image = imread('set1/00000025.jpg');
image = double(image);
%CHROMY Summary of this function goes here
%   Detailed explanation goes here
something = image(:,:,1) + image(:,:,2) + image(:,:,3);
r = image(:,:,1) ./ something;
g = image(:,:,2) ./ something;
s = (image(:,:,1) + image(:,:,2) + image(:,:,3)) / (3*255.0);
chrome_image(:,:,1) = r;
chrome_image(:,:,2) = g;
chrome_image(:,:,3) = s;
end