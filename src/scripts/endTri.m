function [ endtri ] = endTri( pts, cntPt, dir)
%UNTITLED2 Summary of this function goes here
%   pts has the index of the points
%   cntPt is the index of the centerpoint being used

endtri = zeros(size(pts,1) + 1 - 2, 3);

for i = 2:size(pts)
    if dir >= 0
        endtri(i-1,:) = [cntPt, pts(i-1), pts(i)];
    else
        endtri(i-1,:) = [cntPt, pts(i), pts(i-1)];
    end
    
end

end

