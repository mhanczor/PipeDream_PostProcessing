function [ prj_cap] = createEndcap(plane_pts, start_proj, end_proj, sen_cld, travel_dir)
%Projects extra points into a plane defined
%   Detailed explanation goes here

%Generate the plane on which to project the points

%Take the cross product to get a normal vector, take another to get the
%plane definition
n = cross(plane_pts(2,:) - plane_pts(1,:), travel_dir);
pn = cross(n, plane_pts(2,:) - plane_pts(1,:));
%Normalize the plane normal vector
pn = pn/(pn*pn')^(1/2);

prj_pts = sen_cld(start_proj:end_proj - 1, :);

%Project all the points onto this plane
prj_cap = prj_pts - repmat(((prj_pts-repmat(plane_pts(1,:), size(prj_pts,1), 1))*pn'), 1, 3).*repmat(pn, size(prj_pts,1),1);


%Once the plane is created, project the set of points that the seedpoint
%identifies 


end

