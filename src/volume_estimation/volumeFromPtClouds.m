function [ volume ] = volumeFromPtClouds( odCloud, imaCloud, viz, curStart, curEnd )
%Calculates the volume between two point clouds
%   Flattened 2.5D clouds only, use prepSensorCloud before this if taking
%   in circular data

% startPt = min(min(odCloud(:,2)), min(imaCloud(:,2)));
% endPt = max(max(odCloud(:,2)), max(imaCloud(:,2)));

%take 1/nsensors of a rotation and project all those points onto the x
%min or xmax.  Removes any points before or after the start/end points
odCloud = addEndPoints(odCloud, curStart, curEnd);
imaCloud = addEndPoints(imaCloud, curStart, curEnd);

if viz
    figure('Name', 'Current Section Clouds')
    hold on
    scatter3(odCloud(:,1), odCloud(:,2), odCloud(:,3), 'r');
    scatter3(imaCloud(:,1), imaCloud(:,2), imaCloud(:,3), 'b');
end

%Triangulate the 2D projection of the clouds
tri_cld1 = custTriangulate(odCloud);
%Check and modify surface normals if needed

disp('OD Mesh Complete')

tri_cld2 = custTriangulate(imaCloud);
disp('IMA Mesh Complete')

%Checking the surface normals twice for now but could probably reduce to
%once
tri_cld1 = normalCheck(tri_cld1, odCloud, -1);
tri_cld2 = normalCheck(tri_cld2, imaCloud, 1);

if viz
    figure('Name', 'Surface Mesh Pre-Intersect Correction')
    hold on
    trisurf(tri_cld1, odCloud(:,1), odCloud(:,2), odCloud(:,3));
    trisurf(tri_cld2, imaCloud(:,1), imaCloud(:,2), imaCloud(:,3));
end



[imaCloud, odCloud] = surfaceIntersectionCorrection( imaCloud, odCloud, tri_cld2, tri_cld1);
disp('Surface Intersections Check Complete');


tri_cld1 = normalCheck(tri_cld1, odCloud, -1);
tri_cld2 = normalCheck(tri_cld2, imaCloud, 1);
disp('Surface Normals Check Complete');


if viz
    figure('Name', 'Surface Mesh with Corrections');
    hold on
    trisurf(tri_cld1, odCloud(:,1), odCloud(:,2), odCloud(:,3));
    trisurf(tri_cld2, imaCloud(:,1), imaCloud(:,2), imaCloud(:,3));
end


%Wrap the edges of the cloud to create a single surface with a single set
%of triangulation vertices

[sideTri, imaCloud] = sideMesh(odCloud, imaCloud);
disp('Wrapped Mesh Complete');

%Convert the points to a single cloud and adjust the indices as needed
cloud = [odCloud; imaCloud];
tri_list = [tri_cld1; tri_cld2 + size(odCloud, 1); sideTri];

%Orient the surface normals to be consistent
% tri_list = orientNormals(tri_list);
% disp('Surface Normals Oriented');

if viz
    figure
    trisurf(tri_list, cloud(:,1), cloud(:,2), cloud(:,3));
end

%Calculate the volume from a point outside of the cloud
minOrig = [min(cloud(:,1)) - 0.01, min(cloud(:,2)) - 0.01, min(cloud(:,3)) - 0.01];
volume = tetVolume(cloud, tri_list, minOrig);

%If you're calculating volume from radial coordinates you need to divide by 2
volume = volume/2;

sprintf('Volume is: %f m^3', volume)

end

