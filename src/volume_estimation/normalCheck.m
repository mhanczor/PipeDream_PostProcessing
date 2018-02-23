function [ cld_tri ] = normalCheck( tl, cloud, dir)
%Verify the correct orientation of the surface normals and change the
%normals if necessary.  Normals should be outward facing.

crossed = cross(cloud(tl(:,2),:) - cloud(tl(:,1),:), cloud(tl(:,3),:) - cloud(tl(:,1),:));

if dir < 0
    chked = crossed(:,3) < 0;
elseif dir > 0
    chked = crossed(:,3) > 0;
end

cld_tri = tl;
cld_tri(~chked,:) = [cld_tri(~chked,2), cld_tri(~chked,1), cld_tri(~chked,3)];

crossed = cross(cloud(cld_tri(:,2),:) - cloud(cld_tri(:,1),:), cloud(cld_tri(:,3),:) - cloud(cld_tri(:,1),:));

if dir < 0
    chked = crossed(:,3) < 0;
elseif dir > 0
    chked = crossed(:,3) > 0;
end


if min(chked) < 1
    error('Surface normal orientation failed');
end

end