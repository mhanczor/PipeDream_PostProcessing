function [ rCloud ] = cart2pol( cloud )
%Convert X,Y,Z to theta, X, radius^2

    %Use the squared radius
    radius = cloud(:,2).^2 + cloud(:,3).^2;
    rCloud = [atan2(cloud(:,2), cloud(:,3)), cloud(:,1), radius];

end

