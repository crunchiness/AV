function [ chrome_image ] = chromy( image )
image = double(image);
temp = image(:,:,1) + image(:,:,2) + image(:,:,3);
r = image(:,:,1) ./ temp;
g = image(:,:,2) ./ temp;
s = (image(:,:,1) + image(:,:,2) + image(:,:,3)) / (3*255.0);
chrome_image(:,:,1) = r;
chrome_image(:,:,2) = g;
chrome_image(:,:,3) = s;
end