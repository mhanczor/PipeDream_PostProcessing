%Inductive sensor, pipe area only

n_max = 2000; %Number of points on the circle, regularly spaced (worst case at set speed)
n_start = 50;
d = 762; %diamater of pipe, mm
r = d/2;

per_error = zeros(n_max - n_start, 3); %number or sides, %error
for n = n_start:n_max
    
    error = pi*r^2 - (1/2)*n*r^2*sin(2*pi/n); %error difference of area of a circle
    approx_dep = pi*r^2 - (1/2)*n*(r-t)^2*sin(2*pi/n); %area of interpolated deposit thickness
    true_dep = pi*(r^2 - (r - t)^2);%area of true deposit thickness
    per_error(n - n_start + 1,:) = [n, 100*(approx_dep - true_dep)/true_dep, error];
    
end


plot(per_error(:,1), per_error(:,2))
title('Area approximation accuracy with N-sided regular polygon')
xlabel('N - Number of points (regularly spaced)')
ylabel('Difference in approx. deposit area to true area(%)')