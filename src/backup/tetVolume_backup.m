function [v_total, dir ] = tetVolume( cloud, tri, origin )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

nCld = cloud - repmat(origin, size(cloud,1), 1);
dir = 0;
v_total = 0;
for i = 1:size(tri,1)
%     vol = (1/6)*(-nCld(tri(i,3),1)*nCld(tri(i,2),2)*nCld(tri(i,1),3) ...
%         + nCld(tri(i,2),1)*nCld(tri(i,3),2)*nCld(tri(i,1),3) ...
%             + nCld(tri(i,3),1)*nCld(tri(i,1),2)*nCld(tri(i,1),2) ...
%                 - nCld(tri(i,1),1)*nCld(tri(i,3),2)*nCld(tri(i,2),3) ...
%                     - nCld(tri(i,2),1)*nCld(tri(i,1),2)*nCld(tri(i,3),3) ...
%                         + nCld(tri(i,1),1)*nCld(tri(i,2),2)*nCld(tri(i,3),3));
%     v_total = v_total + vol;     
    vol = (1/6)*dot(cloud(tri(i,3), :) - origin, cross(cloud(tri(i,1), :) - origin, cloud(tri(i,2), :) - origin));
    snorm = cross(nCld(tri(i,2), :) - nCld(tri(i,1), :), nCld(tri(i,3),:) - nCld(tri(i,1),:))
    v_total = v_total + vol;
    
    dir = [dir; dot(nCld(tri(i,1),:), snorm)];
end

% dir = dir(2:end,:);

end