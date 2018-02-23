function [ orientedList ] = orientNormals( tri_list )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Orient all the surface normals to be pointing in the direction of the
%first surface normal so they are all consistent. This is an operation on
%the vertices so we don't need the actual points

%Set the first triangle's orientation as the orientation for the rest of
%the cloud
tl_og = size(tri_list,1);
orientedList = tri_list(1,:);
tri_list = tri_list(2:end,:);
%
w_i = 1;
while size(tri_list,1) > 0
    %disp(100 * size(orientedList, 1) / tl_og)
    %Look at the three possible edge combinations
    for i = 1:3
        
        %Find all other triangles with the same first vertex
        inds_1 = find(tri_list == orientedList(w_i,i));
        if size(inds_1, 1) > 0
            
            [rows_1, cols_1] = ind2sub(size(tri_list), inds_1);
            
            v_shortlist = tri_list(rows_1,:);
            
            if i == 3
                inds_2 = find(v_shortlist == orientedList(w_i, 1));
            else 
                inds_2 = find(v_shortlist == orientedList(w_i, i+1));
            end
            
            if size(inds_2, 1) == 1 && size(inds_2, 2) > 0
                %Probably don't need this since you know there's only one
                %avlue anyways
                [rows_2, cols_2] = ind2sub(size(v_shortlist), inds_2);
                rot2 = 0;
                if cols_1(rows_2) - cols_2 == -1
                    rot2 = 1;
                    %then the rotation is positive
                elseif cols_1(rows_2) - cols_2 == -2
                    rot2 = -1;
                    %then the rotation is negative
                elseif cols_1(rows_2) - cols_2 == 2
                    rot2 = 1;
                    %then the rotation is positive
                elseif cols_1(rows_2) - cols_2 == 1
                    rot2 = -1;
                    %then the rotation is negative
                else
                    error('Error finding the line direction')
                end
                
                %Check to see if the rotation is in the same direcion or
                %not
                if rot2 > 0
                    %if it's in the same direction, add the triangle to the
                    %oriented list after switching the vertices
                    tr = rows_1(rows_2);
                    orientedList = [orientedList; tri_list(tr,2), tri_list(tr,1), tri_list(tr,3)];
                    tri_list(tr,:) = [];
                else
                    tr = rows_1(rows_2);
                    orientedList = [orientedList; tri_list(tr,:)];
                    tri_list(tr,:) = [];
                end
            elseif size(inds_2, 1) > 1
                error('More than 2 triangles share a line');
            end
        end        
        
    end
    
    w_i = w_i + 1;
end
end
