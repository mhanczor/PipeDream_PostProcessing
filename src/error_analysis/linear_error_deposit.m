n_max = 150; %Number of points on the circle, regularly spaced (worst case at set speed)
n_start = 50;
d = 762; %diamater of pipe, mm
t = 0.69;% mm deposit thickness
r = d/2;

per_error = zeros(n_max - n_start, 3); %number or sides, %error
for n = n_start:n_max
    
    error = pi*r^2 - (1/2)*n*r^2*sin(2*pi/n); %error difference of area of a circle
    true_area = pi*r^2;
    threshold_area = true_area - pi*(r-t)^2;
    per_threshold = 100 * error / threshold_area;
    per_error(n - n_start + 1,:) = [n, error, per_threshold];
    
end


plot(per_error(:,1), per_error(:,3))
title('Percent difference of approximated circle area to threshold deposit area')
xlabel('N - Number of points (regularly spaced)')
ylabel('Area difference between approximated circle and threshold (%)')


% plot(per_error(:,1), per_error(:,2))
% title('Area approximation difference of a circle with N-sided regular polygon')
% xlabel('N - Number of points (regularly spaced)')
% ylabel('Area difference between true and approximated cirlces (mm^2)')

