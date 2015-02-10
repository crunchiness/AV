function [ h_number ] = probability_box( weights )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

N_HYP = size(weights);
index = rand * N_HYP;
total_sum = 0;
for i = 1:N_HYP
    total_sum = total_sum + weights(i);
    if total_sum < index
        break
    end
end

h_number = i;
end

