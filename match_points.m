function [ matches, colors, radii ] = match_points( prev_coords, colors, detected_coords, detected_colors,radii)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%TODOs
    s = size(prev_coords,1);
    matches = zeros(s,1);
    uncolored = []; % x, y, original index
    yellow_p = [];
    pink_p = [];
    white_p = [];
    max_d = 100;
    % segment previous
    for i=1:s
        if colors(i) == 0
            uncolored(end+1,1) = prev_coords(i,1);
            uncolored(end,2) = prev_coords(i,2);
            uncolored(end,3) = i;
        elseif colors(i) == 1
            yellow_p(end+1,1) = prev_coords(i,1);
            yellow_p(end,2) = prev_coords(i,2);
            yellow_p(end,3) = i;
        elseif colors(i) == 2
            pink_p(end+1,1) = prev_coords(i,1);
            pink_p(end,2) = prev_coords(i,2);
            pink_p(end,3) = i;
        elseif colors(i) == 3
            white_p(end+1,1) = prev_coords(i,1);
            white_p(end,2) = prev_coords(i,2);
            white_p(end,3) = i;
        end
    end

    % segment detected
    yellow_d = [];
    pink_d = [];
    white_d = [];
    for i=1:length(detected_colors)
        if detected_colors(i) == 1
            yellow_d(end+1,1) = detected_coords(i,1);
            yellow_d(end,2) = detected_coords(i,2);
            yellow_d(end,3) = i;
        elseif detected_colors(i) == 2
            pink_d(end+1,1) = detected_coords(i,1);
            pink_d(end,2) = detected_coords(i,2);
            pink_d(end,3) = i;
        elseif detected_colors(i) == 3
            white_d(end+1,1) = detected_coords(i,1);
            white_d(end,2) = detected_coords(i,2);
            white_d(end,3) = i;
        end
    end
    % match yellow
    if size(yellow_d,1) ~= 0 && size(yellow_p,1) ~= 0
        for i=1:size(yellow_p,1)
            [d,p] = min((yellow_d(:,1)-yellow_p(i,1)).^2 + (yellow_d(:,2)-yellow_p(i,2)).^2);
            index = yellow_d(p,3);
            if find(index==matches)
            elseif d < max_d
                asdf = 'yellow'
                matches(yellow_p(i,3)) = index;
            end
        end
    end

    % match pink
    if size(pink_d,1) ~= 0 && size(pink_p,1) ~= 0
        for i=1:size(pink_p,1)
            [d,p] = min((pink_d(:,1)-pink_p(i,1)).^2 + (pink_d(:,2)-pink_p(i,2)).^2);
            index = pink_d(p,3);
            if find(index==matches)
            elseif d < max_d
                asdf = 'pink'
                matches(pink_p(i,3)) = index;
            end
        end
    end

    % match white
    if size(white_d,1) ~= 0 && size(white_p,1) ~= 0
        for i=1:size(white_p,1)
            [d,p] = min((white_d(:,1)-white_p(i,1)).^2 + (white_d(:,2)-white_p(i,2)).^2);
            index = white_d(p,3);
            if find(index==matches)
            elseif d < max_d
                asdf = white
                matches(white_p(i,3)) = index;
            end
        end
    end
    unused_d = [];
    % find unused detected
    for i = 1:length(detected_colors)
        if find(i==matches)
        else
            unused_d(end+1,1) = detected_coords(i,1);
            unused_d(end,2) = detected_coords(i,2);
            unused_d(end,3) = i;
        end
    end
    
    % assign randomly to uncolored (they don't have coords yet)
    if size(unused_d,1) ~= 0 && size(uncolored,1) ~= 0
        for j = 1:size(uncolored,1)
            index = uncolored(j,3);
            if matches(index) == 0
                for k = 1:size(unused_d,1)
                    if unused_d(k,3) > 0
                        matches(index) = unused_d(k,3);
                        unused_d(k,3) = 0;
                        break;
                    end
                end
            end
        end
    end

    % update colors
    for i=1:size(matches)
        if matches(i) ~= 0 && colors(i) == 0
            colors(i) = detected_colors(matches(i));
        end
    end
    for i=1:size(matches)
        if matches(i) == 0
            radii(i) = NaN;
        else
            radii(i) = radii(matches(i));
        end
    end
end