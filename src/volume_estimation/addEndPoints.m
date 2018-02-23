function [ padCloud ] = addEndPoints( cloud, startPt, endPt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


%Find the first point along the x direction and the last point
% minPt = min(cloud(:,2));
% endPt= max(cloud(:,2));

theta = (-pi:2*pi/100:pi)';


%Create a seach cloud where the second axis (previously 2pi) is convereted
%to arc length distance between points for better approx NN, use 29" as the
%diameter for conversion

%Nominal approx radius of the pipe, for NN
radConver = 0.3683;

%Stretched cloud along the 2pi axis to arclength
sCloud = [cloud(:,1)*radConver, cloud(:,2)];
    

%Finds the 1-NN of the start points before the section and after the start 
searchPts = [theta*radConver, ones(size(theta,1),1)*startPt];
[startNN_0, sD_0] = knnsearch(sCloud(sCloud(:,2) >= startPt, :), searchPts);
tmp = cloud(sCloud(:,2) >= startPt, 3);
%Save the correctly indexed z values that will be used
sNN_R0 = tmp(startNN_0);

[startNN_1, sD_1] = knnsearch(sCloud(sCloud(:,2) < startPt, :), searchPts);
tmp = cloud(sCloud(:,2) < startPt, 3);
sNN_R1 = tmp(startNN_1);

%Find the 1-NN of the end points before and after the section 
searchPts = [theta*radConver, ones(size(theta,1),1)*endPt];
[endNN_0, eD_0] = knnsearch(sCloud(sCloud(:,2) <= endPt ,:), searchPts);
tmp = cloud(sCloud(:,2) <= endPt, 3);
eNN_R0 = tmp(endNN_0);

[endNN_1, eD_1] = knnsearch(sCloud(sCloud(:,2) > endPt ,:), searchPts);
tmp = cloud(sCloud(:,2) > endPt, 3);
eNN_R1 = tmp(endNN_1);

%Using the weighted average of the two NN found, set the height of each
%point.

if isempty(startNN_1)
    padStart = sNN_R0;
else
    padStart = (1 - sD_0./(sD_0+sD_1)).*sNN_R0 + (1 - sD_1./(sD_0+sD_1)).*sNN_R1;
end

if isempty(endNN_1)
    padEnd = eNN_R0;
else
    padEnd = (1 - eD_0./(eD_0+eD_1)).*eNN_R0 + (1 - eD_1./(eD_0+eD_1)).*eNN_R1;
end

%Set the points at -pi to pi, startPt, height found from the linear interp
padCloud = [theta, ones(size(startNN_0,1),1)*startPt, padStart; theta, ones(size(endNN_0,1),1)*endPt, padEnd];


%Reduce the cloud so it only has points within the desired range
cloud(cloud(:,2) < startPt, :) =[];
cloud(cloud(:,2) > endPt, :) =[];

padCloud = [cloud; padCloud];

end

