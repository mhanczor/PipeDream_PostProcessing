function [ modIMACloud, modODCloud ] = surfaceIntersectionCorrection( imaCloud, odCloud, imaTri, odTri)
%Finds areas where the ODMini surface is beyond the IMA surface and adjusts
%the IMA points to move to the OD points
%   The IMA cloud is moved since it is considered less accurate than the OD
%   cloud.  The first step is moving all the individual points that are
%   below the odCloud up to the odCloud surfaces.  Second, any surface
%   intersections remaining need to be addressed. 


%If there are no odmini points above any of the IMA points there is no way
%that there could be a surface intersection.
if min(imaCloud(:,3)) >= max(odCloud(:,3))
    modIMACloud = imaCloud;
    modODCloud = odCloud;
    disp('No surface intersections')
    return
elseif max(imaCloud(:,3)) <= min(odCloud(:,3))
    warning('No IMA points above any OD points, possible confusion in the cloud labeling.');
end

%Create a new mat for the ima points since this should whittle down over
%the course of the function
cldList = [imaCloud, (1:size(imaCloud,1))'];
triList = imaTri;

modIMACloud = imaCloud;
modODCloud = odCloud;

intersections = 0;
for i = 1:size(odTri,1)
    v1 = odCloud(odTri(i,1),1:2);
    v2 = odCloud(odTri(i,2),1:2);
    v3 = odCloud(odTri(i,3),1:2);
%     T = [v1(1) - v3(1), v2(1) - v3(1);
%          v1(2) - v3(2), v2(2) - v3(2)];
    vectPts = cldList(:,1:2) - repmat(v3, size(cldList,1),1);
    nm = (v2(2) - v3(2))*(v1(1) - v3(1)) + (v3(1)-v2(1))*(v1(2)-v3(2));
    l1 = [v2(2)-v3(2), v3(1)-v2(1)]*vectPts';
    l1 = l1./nm;
    l2 = [v3(2)-v1(2), v1(1)-v3(1)]*vectPts';
    l2 = l2./nm;
    l3 = ones(size(l1',1),1)-l2'-l1';
    barPts = [l1', l2', l3];
    
    intPts = ((min(barPts') >= 0) .* (max(barPts') <=1))';
    
    posIntPts = cldList(intPts == 1,:);
    if ~isempty(posIntPts)
        
        N = cross(modODCloud(odTri(i,2),:)-modODCloud(odTri(i,1),:), modODCloud(odTri(i,3),:)-modODCloud(odTri(i,1),:));
        N = N ./ (sqrt(N(1)^2+N(2)^2+N(3)^2));
        d = -N*modODCloud(odTri(i,1),:)';
        dv = (N*posIntPts(:,1:3)'+repmat(d, 1, size(posIntPts,1)))';
        idxs = posIntPts(dv > 0,4);
               
        %Project the points below the surface up to the surface
        if ~isempty(idxs)
             cldAdjust = (-1/N(3))*(repmat(d,size(idxs,1),1) ...
                + N(1).*(modIMACloud(idxs,1)-repmat(odCloud(odTri(i,1),1),size(idxs,1),1)) ...
                + N(2).*(modIMACloud(idxs,2)-repmat(odCloud(odTri(i,1),2),size(idxs,1),1))) + repmat(odCloud(odTri(i,1),3),size(idxs,1),1);
            cldAdjust(cldAdjust > max(odCloud(odTri(i,:),3))) = max(odCloud(odTri(i,:),3));
            cldAdjust(cldAdjust < min(odCloud(odTri(i,:),3))) = min(odCloud(odTri(i,:),3));
            modIMACloud(idxs,3) = cldAdjust;
        end
        intersections = intersections + size(posIntPts,1);
        cldList(intPts == 1,:) = [];
    end

    
    if min(size(cldList)) == 0
        break
    end
        
end

if intersections < size(imaCloud,1)
    warning('VolEst:SurfaceCheck','Not all points were checked for surface intersection errors')
end

end

