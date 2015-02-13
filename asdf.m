    imshow(orig_current);
    hold on
        
            for u =1: size(radii)
                x = centers(u,1);
                y = centers(u,2);
                if detected_colors(u) == 1
                    color_name = 'yellow';
                elseif detected_colors(u) == 2
                    color_name = 'red';
                elseif detected_colors(u) == 3
                    color_name = 'white';
                else
                    color_name = 'black';
                end
                temp(i,u,1)=x ;
                temp(i,u,2)=y ;
                
                viscircles([x, y], radius, 'LineWidth', 1, 'EdgeColor', color_name, 'DrawBackgroundCircle', false);
                hold on;
                plot(x, y, 'gx');
%             text(double(x), double(y), num2str(k))
            end
           

