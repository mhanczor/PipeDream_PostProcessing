function [v_total] = tetVolume( cloud, tri, origin )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

v_total = 0;
for i = 1:size(tri,1) 
    
    vol = (1/6)*dot(cloud(tri(i,3), :) - origin, cross(cloud(tri(i,1), :) - origin, cloud(tri(i,2), :) - origin));
    v_total = v_total + vol;
end

end