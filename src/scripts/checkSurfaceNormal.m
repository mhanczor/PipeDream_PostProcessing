function [ norm ] = checkSurfaceNormal( V )
%Returns the surface normal of a triangle
%   vertices are the three vertices in order (V1, V2, V3) for triangulation

    norm = cross(V(2,:) - V(1,:), V(3,:) - V(1,:));


end

