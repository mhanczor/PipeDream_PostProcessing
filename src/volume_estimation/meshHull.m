function [ hull_ind ] = meshHull( cloud )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

    hull_ind = convhull(cloud(:,1), cloud(:,2));
   
end

