%% Volume Estimation Script

%First run pointcloud gen or make it into a function you can run from here

%Direction the robot is travelling in, for this sim it's positive z
travel_dir = [0,0,1];

%Now have odmini1 and odmini2 with their full [x,y,z] coordinates of points

od1_sz = size(odmini1, 1);
od2_sz = size(odmini2, 1);

%TEMPORARY SEED INDEX, need to come up with a NN approach to this
%This is the index of the point on the odmini2 scan that odmini1's first
%point is nearest to
od1_start_seed = 1+(round(samp_freq/(rotation_freq*2)));
od2_start_seed = 1+(round(samp_freq/(rotation_freq*2)));

%Cap each side of the mesh with additional points in the plane of the two
%start or end points

%The points that make up a plane are the first points for each sensor and
%the last points for each sensor.
plane_pts = [odmini1(1,:); odmini2(1,:); odmini1(end,:); odmini2(end,:)];


%After this is done both clouds should be checked to make sure no points
%fall before or after these capping planes in case of sensor wobble or tf
%error.  If they do they should be removed

%Cap the first sensor start and finish

startCap1 = createEndcap(plane_pts(1:2,:), 1, od1_start_seed, odmini2, travel_dir);
startCap2 = createEndcap(plane_pts(1:2,:), 1, od2_start_seed, odmini1, travel_dir);
od1_capped = [startCap1; odmini1];
od2_capped = [startCap2; odmini2];

od1_cap_sz = size(od1_capped,1);
od2_cap_sz = size(od2_capped,1);

od1_stop_seed = od2_cap_sz - (round(samp_freq/(rotation_freq*2))) + 1;
od2_stop_seed = od1_cap_sz - (round(samp_freq/(rotation_freq*2))) + 1;

endCap1 = createEndcap(plane_pts(3:4,:), od1_stop_seed, size(od2_capped), od2_capped, travel_dir);
endCap2 = createEndcap(plane_pts(3:4,:), od2_stop_seed, size(od1_capped), od1_capped, travel_dir);
od1_capped_t = [od1_capped; endCap1];
od2_capped_t = [od2_capped; endCap2];

od1_capped = od1_capped_t;
od2_capped = od2_capped_t;

%Get the size of each individual cloud, these set the index for the entire
%cloud

od1_cap_sz = size(od1_capped,1);
od2_cap_sz = size(od2_capped,1);

cloud = [od1_capped; od2_capped];



%Start and end values
od1_start1 = 1;
od1_start2 = 1+(round(samp_freq/(rotation_freq*2))); 

od2_start1 = od1_cap_sz + 2 + (round(samp_freq/(rotation_freq*2)));
od2_start2 = od1_cap_sz + 1;

od1_stop1 = od1_cap_sz - round((samp_freq/(rotation_freq*2))) + 1;
od1_stop2 = od1_cap_sz;

od2_stop1 = od1_cap_sz + od2_cap_sz;
od2_stop2 = od1_cap_sz + od2_cap_sz - round((samp_freq/(rotation_freq*2))) + 1;


tri_list = fringe_triangulation(cloud, od1_start1, od1_stop1, od2_start1, od2_stop1);
tri_list = [tri_list; fringe_triangulation(cloud, od2_start2, od2_stop2, od1_start2, od1_stop2)];

ptsStart = [(1:1:size(startCap1, 1))'; (od1_cap_sz + 1:1:od1_cap_sz + 1+size(startCap2,1))'];
ptsEnd = [od1_cap_sz+od2_cap_sz;((od1_cap_sz - size(endCap1,1)):1:od1_cap_sz)'; ((od1_cap_sz + od2_cap_sz - size(endCap2,1)):1:od1_cap_sz + od2_cap_sz)'];

endtri1 = endTri(ptsStart, size(cloud,1) + 1, 1);

endtri2 = endTri(ptsEnd, size(cloud,1) + 2, -1);


cloud = [cloud; 0,0,0,; 0,0,max(cloud(:,3))];

tri_list = [tri_list; endtri1; endtri2];



%% Plot Points
close all

figure
hold on
scatter3(od1_capped(:,1), od1_capped(:,2), od1_capped(:,3), 'b');
scatter3(od2_capped(:,1), od2_capped(:,2), od2_capped(:,3), 'o');

%% Plot mesh
figure
trisurf(tri_list, cloud(:,1), cloud(:,2), cloud(:,3))


%% Volume Calc

volume = tetVolume(cloud, tri_list, [0, 0, -10]);
volume = abs(volume);

len = max(cloud(:,3)) - min(cloud(:,3));
762; % pipe diameter [mm]
r = d/2; % radius [mm]

% true_vol = pi*r^2*len

% error = true_vol - volume

% per_error = 100 * error/true_vol

