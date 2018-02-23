%% Generate a Uniform Deposit
close all
clear

%This is to test meshing methods, no sensor noise and an easy to calculate
%volume for comparison.

d = 800; % pipe diameter [mm] 762 nominal, 800 IMA
r = d/2; % radius [mm]
t = 0.69; % deposit thickness [mm]
L = 3000; % pipe length [mm]

scans = 2; % full 360 degree scans to take:

samp_freq = 10; %frequency of the triangulation sensor measurements [1/s]
rotation_freq = 0.51; %frequency of the sensor disk rotation [1/s]
trans_speed = 30.48; %speed of the robot down the pipe [mm/s]

scan_time = scans/rotation_freq; %total scan time [s]

dep_interior_volume = pi*r^2*L; %The volume on the interior of the deposit

gen_cloud = zeros(round(scan_time*samp_freq), 3); %time step is every triangulation measurement

angle = 0;
for i = 0:size(gen_cloud, 1)-1
    scan_dist = r - t;
    angle = i*2*pi*rotation_freq/samp_freq; 
    z = scan_dist*sin(angle);
    y = scan_dist*cos(angle);
    x = i*trans_speed/samp_freq;
    gen_cloud(i+1,:) = [x, y, z];
end

odmini1 = gen_cloud;
odmini2 = [gen_cloud(:,1), gen_cloud(:,2:3)*-1];
%gen_cloud = [gen_cloud; gen_cloud(:,1:2)*-1, gen_cloud(:,3)];


%% Save and print

full_cloud = [odmini1; odmini2];

scatter3(full_cloud(:,1), full_cloud(:,2), full_cloud(:,3), '.');

cloud = full_cloud;

% save('twenty_scans.txt', 'full_cloud', '-ascii', '-tabs');




