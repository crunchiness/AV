function [ matches, colors ] = match_points( previous, colors, detected, detected_colors )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%TODOs
    s = size(previous,1);
    matches = zeros(s,1);
    uncolored = []; % x, y, original index
    yellow_p = [];
    pink_p = [];
    white_p = [];
    max_d = 80;
    % segment previous
    for i=1:s
        if colors(i) == 0
            uncolored(end+1,1) = previous(i,1);
            uncolored(end,2) = previous(i,2);
            uncolored(end,3) = i;
        elseif colors(i) == 1
            yellow_p(end+1,1) = previous(i,1);
            yellow_p(end,2) = previous(i,2);
            yellow_p(end,3) = i;
        elseif colors(i) == 2
            pink_p(end+1,1) = previous(i,1);
            pink_p(end,2) = previous(i,2);
            pink_p(end,3) = i;
        elseif colors(i) == 3
            white_p(end+1,1) = previous(i,1);
            white_p(end,2) = previous(i,2);
            white_p(end,3) = i;
        end
    end

    % segment detected
    yellow_d = [];
    pink_d = [];
    white_d = [];
    for i=1:length(detected_colors)
        if detected_colors(i) == 1
            yellow_d(end+1,1) = detected(i,1);
            yellow_d(end,2) = detected(i,2);
            yellow_d(end,3) = i;
        elseif detected_colors(i) == 2
            pink_d(end+1,1) = detected(i,1);
            pink_d(end,2) = detected(i,2);
            pink_d(end,3) = i;
        elseif detected_colors(i) == 3
            white_d(end+1,1) = detected(i,1);
            white_d(end,2) = detected(i,2);
            white_d(end,3) = i;
        end
    end
    % match yellow
    if size(yellow_d,1) ~= 0 && size(yellow_p,1) ~= 0
        for i=1:size(yellow_p,1)
            [d,p] = min((yellow_d(:,1)-yellow_p(i,1)).^2 + (yellow_d(:,2)-yellow_p(i,2)).^2);
            index = yellow_d(p,3)
            if find(index==matches)
            elseif d < max_d
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
                matches(white_p(i,3)) = index;
            end
        end
    end
    unused_d = [];
    % find unused detecteddetecte
    for i = 1:length(detected_colors)
        if find(i==matches)
        else
            unused_d(end+1,1) = detected(i,1);
            unused_d(end,2) = detected(i,2);
            unused_d(end,3) = i;
        end
    end
    if size(unused_d,1) ~= 0 && size(uncolored,1) ~= 0;
        for i=1:size(uncolored,1)
            [d,p] = min((unused_d(:,1)-uncolored(i,1)).^2 + (unused_d(:,2)-uncolored(i,2)).^2);
            index = unused_d(p,3);
            if find(index==matches)
            elseif d < max_d
                matches(uncolored(i,3)) = index;
            end
        end
    end

    % update colors
    for i=1:size(matches)
        if matches(i) ~= 0 && colors(i) == 0
            colors(i) = detected_colors(matches(i));
        end
    end
end