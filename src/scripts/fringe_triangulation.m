function [ tri_list ] = fringe_triangulation( cloud, sen1_start, sen1_end, sen2_start, sen2_end)
%Triangulates a set of points generated in a helical pattern.  
%   This function takes in two sets of sensor data, with the first sensor
%   being the closest to the start of the pipe (for normal purposes
%   sen1_st are the starting points of the helixes in the context of the
%   entire point cloud for triangulation

%   Inputs:
%       cloud = nx3 cloud of all sensor points stacked
%       sen1_start = global index position of the first point to be used
%       for the triangulation 
%       sen1_end = global index of the last point to be used
%       sen2_start = global index position of the first point to be used
%       for the triangulation 
%       sen2_end = global index of the last point to be used


%For now have them both start at the same location, a prepicked closest
%point, later on this may be done by a function ahead of time or done here

sen1_cur = sen1_start;
sen2_cur = sen2_start;

sen1_sz = sen1_end - sen1_start + 1;
sen2_sz = sen2_end - sen2_start + 1;

%Store all the points (three points each for the vertices in order) in a
%list
tri_list = zeros(sen1_sz + sen2_sz - 2, 3);

%index value
w_i = 1;
while true
    %Create a freakin distance function duh (make it the squared norm not
    %the sqrt norm)
    
    %Check to see if it's possible to iterate further 
    if sen2_cur + 1 < sen2_start + sen2_sz
        if sen1_cur + 1 < sen1_start + sen1_sz
            %If both values can iterate then it will compare the length to the
        %next triangle for both options, picking the shortest
            if pdist([cloud(sen1_cur,:); cloud(sen2_cur + 1, :)]) < pdist([cloud(sen1_cur+1,:); cloud(sen2_cur, :)])
                tri_list(w_i, :) = [sen1_cur, sen2_cur, sen2_cur + 1,];
                sen2_cur = sen2_cur + 1; 
            else
                tri_list(w_i, :) = [sen1_cur, sen2_cur, sen1_cur + 1];
                sen1_cur = sen1_cur + 1;
            end
        else
            tri_list(w_i, :) = [sen1_cur, sen2_cur, sen2_cur + 1];
            sen2_cur = sen2_cur + 1; 
        end
        
    elseif sen1_cur + 1 < sen1_start + sen1_sz
        
        tri_list(w_i, :) = [sen1_cur, sen2_cur, sen1_cur + 1];
        sen1_cur = sen1_cur + 1;
        
    else
        break
    end

    w_i = w_i + 1;
end

end

