function [ filledCloud ] = addTransitionPoints( cloud, direction )
%A flattened clouds with data theta, x, radius is the input.
%   This function will take the data and add points at pi and -pi along the
%   length of the cloud with the radius being a linear interpolation
%   between the two points.

addedPts = [];
for i = 1: size(cloud,1) - 1
    
    %check to see if a points went from the range -pi/0 to pi/0 and if
    %so, add transition points
    if cloud(i,1) < 0 && cloud(i+1,1) > 0 && strcmp(direction, 'CW')
        %Then there has been a transition in the CW direction
        if cloud(i,1) == -pi
            if cloud(i+1,1) == pi
                continue
            else
                addedPts = [addedPts; pi, cloud(i,2:3)];
            end
        elseif cloud(i+1,1) == pi
            addedPts = [addedPts; -pi, cloud(i+1, 2:3)];
        else
            %Write this equation and then run through all the code to see
            %if it makes sense!!!!
            
            ptHeight = cloud(i,3) + (pi - (cloud(i,1) + 2*pi))*(cloud(i+1, 3) - cloud(i,3))/(cloud(i+1,1) - (cloud(i,1) + 2*pi));
            ptDist = cloud(i,2) + (pi - (cloud(i,1) + 2*pi))*(cloud(i+1, 2) - cloud(i,2))/(cloud(i+1,1) - (cloud(i,1) + 2*pi));
            addedPts = [addedPts; -pi, ptDist, ptHeight; pi, ptDist, ptHeight];
        end
        
    elseif cloud(i,1) > 0 && cloud(i + 1,1) < 0 && strcmp(direction, 'CCW')
        %Then there has been a transition in the CCW direction
        
        if cloud(i,1) == pi
            if cloud(i+1,1) == -pi
                continue
            else
                addedPts = [addedPts; -pi, cloud(i,2:3)];
            end
            
        elseif cloud(i+1, 1) == -pi
            addedPts = [addedPts; pi, cloud(i+1, 2:3)];
        else
            %Linearly interpolate between the two points to find the
            %height of the surface at that point
            ptHeight = cloud(i,3) + (-pi - (cloud(i,1) + 2*pi))*(cloud(i+1, 3) - cloud(i,3))/(cloud(i+1,1) - (cloud(i,1) - 2*pi));
            ptDist = cloud(i,2) + (-pi - (cloud(i,1) - 2*pi))*(cloud(i+1, 2) - cloud(i,2))/(cloud(i+1,1) - (cloud(i,1) - 2*pi));
            addedPts = [addedPts; pi, ptDist, ptHeight; -pi, ptDist, ptHeight];
        end
    else
        %There has been no transition
        continue        
    end
end

filledCloud = [cloud; addedPts];

end

