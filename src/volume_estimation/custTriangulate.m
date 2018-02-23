function [ tri_list ] = custTriangulate( cloud )
%Triangulate 2.5D points by projection onto a 2D plane
%   The input cloud should have dimensions in x,y,z or theta, z and radius.
%   The cloud loses it's third dimension (z or radius) before triangulation

    tri_list = delaunay(cloud(:,1), cloud(:,2));
end

