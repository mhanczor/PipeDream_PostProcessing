function [ sideTri, modCloud2] = sideMesh( cloud1, cloud2)
%UNTITLED7 Summary of this function goes here
%   Returns the triangulated sides of the two clouds to connect them in an
%   index where cloud1 is directly before cloud2

%This depends on the hull points not overlapping, need to check for this

% Get the convex hull of the first cloud (return local indexes)
    h1_ind = meshHull(cloud1);
    
% Get the convex hull of the second cloud (return local indexes)
    h2_ind = meshHull(cloud2);
    
    %Remove the last value, will be added back after
    h1_ind = h1_ind(1:end-1, :);
    h2_ind = h2_ind(1:end-1, :);
    
%For the first point of the first hull find the nearest point on the
%second hull.  These will be the starting points 
    c1_start = 1;
    pre_len = 100000;
    for i = 1:size(h2_ind,1)
        len = pdist2(cloud1(h1_ind(c1_start),:), cloud2(h2_ind(i),:));
        if len < pre_len
            h2_start = i;
            pre_len = len;
        end
    end
    
%when porting you may want to use the top (inductive) cloud as the
%starting cloud to reference off of since the sampling rate is higher for
%the odmini
    
    h2_ind = [h2_ind(h2_start:end); h2_ind(1:h2_start-1)];
    
    %Convert the second cloud to be in the global index
    h2_ind = h2_ind + size(cloud1, 1);
    
    cloud = [cloud1; cloud2];
    
    
    
    %add the first points to the end of the list so the hull is watertight
    h1_ind = [h1_ind; h1_ind(1)];
    h2_ind = [h2_ind; h2_ind(1)];
    
    sideTri = zeros(size(h1_ind, 1) + size(h2_ind, 1) - 2, 3);
    
    %Look at the next available points, one for each cloud, and form the
%triangle with the shortest length side.  If there is an intersection (need
%to check for one) then the second cloud's point is shifted down to the height of the intersection
h1_cur = 1;
h2_cur = 1;

modCloud2 = cloud2;

%Handle flipped surfaces
if cloud(h2_ind(h2_cur,:), 3) < cloud(h1_ind(h1_cur),3)
    modCloud2(h2_ind(h2_cur,:),3) = cloud(h1_ind(h1_cur),3);
end


%Should change the point movements to be so there is no intersection still

% Remove these points from a list of available hull points, 
% these points should be in global index

    w_i = 1;
    while true
        
        if h1_cur < size(h1_ind, 1)
            if h2_cur < size(h2_ind,1)
                
                %if the IMA next point is further away and below the current or next od point,
                    %raise the point to the height of the point
                    
                    
                if (cloud(h2_ind(h2_cur + 1), 3) < cloud(h1_ind(h1_cur ),3)) && pdist([cloud(h2_ind(h2_cur), :); cloud(h1_ind(h1_cur), :)])
                    modCloud2(h2_ind(h2_cur+1,:) - size(cloud1, 1),3) = cloud(h1_ind(h1_cur),3);
                elseif (cloud(h2_ind(h2_cur + 1), 3) < cloud(h1_ind(h1_cur+1),3)) && pdist([cloud(h2_ind(h2_cur), :); cloud(h1_ind(h1_cur+1), :)])
                    modCloud2(h2_ind(h2_cur+1,:) - size(cloud1, 1),3) = cloud(h1_ind(h1_cur+1),3);
                end
                
                c1_c2_dist = pdist([cloud(h1_ind(h1_cur), :); cloud(h2_ind(h2_cur + 1), :)]);
                c2_c1_dist = pdist([cloud(h1_ind(h1_cur + 1),:); cloud(h2_ind(h2_cur), :)]);
                
                if c1_c2_dist < c2_c1_dist
                    sideTri(w_i, :) = [h2_ind(h2_cur), h1_ind(h1_cur), h2_ind(h2_cur + 1)];
                    h2_cur = h2_cur + 1;
                else
                    sideTri(w_i,:) = [h2_ind(h2_cur), h1_ind(h1_cur),  h1_ind(h1_cur+1)];
                    h1_cur = h1_cur + 1;
                end
            else
                sideTri(w_i, :) = [h1_ind(h1_cur), h1_ind(h1_cur + 1), h2_ind(h2_cur)];
                h1_cur = h1_cur + 1;
                
            end 
            
        elseif h2_cur < size(h2_ind,1)
            %Approximate fix to surface intersection
            if (cloud(h2_ind(h2_cur + 1), 3) < cloud(h1_ind(h1_cur ),3)) && pdist([cloud(h2_ind(h2_cur), :); cloud(h1_ind(h1_cur), :)])
                modCloud2(h2_ind(h2_cur+1,:) - size(cloud1, 1),3) = cloud(h1_ind(h1_cur),3);
            end
            
            sideTri(w_i,:) = [h2_ind(h2_cur), h1_ind(h1_cur), h2_ind(h2_cur+1)];
            h2_cur = h2_cur + 1;
        else
            break
        end
        
        w_i = w_i + 1;
        
    end
    

        
        
%All points should be connected now, return the triangulation points


end

