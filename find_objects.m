function [objects, mask_global] = find_objects(w, h, boundaries, draw_shapes)
    objects = [];
    mask_global = [];
    if draw_shapes
        mask_global = zeros(h, w);
    end
    for i = 1 : length(boundaries)
        % get top left and bottom right points of the pbject
        yMin = min(boundaries{i}(:,1));
        yMax = max(boundaries{i}(:,1));
        xMin = min(boundaries{i}(:,2));
        xMax = max(boundaries{i}(:,2));
        if draw_shapes
            mask = zeros(h, w);
            for j = 1 : length(boundaries{i})
                coords = boundaries{i}(j,:);
                mask(coords(1),coords(2)) = 1;
            end
        end
        %mask = imfill(mask, 'holes');
        bounding_box = [xMin, yMin, xMax, yMax];
        [is_ball, center_coords, radius] = check_if_ball(boundaries{i}, bounding_box);
        if is_ball && draw_shapes
            objects(end+1).mask = mask;
            objects(end).center = center_coords;
            objects(end).boundingBox = bounding_box;
            objects(end).radius = radius;
        elseif is_ball
            objects(end+1).center = center_coords;
            objects(end).boundingBox = bounding_box;
            objects(end).radius = radius;
        elseif draw_shapes
            mask = mask * -1;
        end
        if draw_shapes
            mask_global = mask_global + mask;
        end
    end
end