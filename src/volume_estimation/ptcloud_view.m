clc, clear, close all

data0 = csvread('bags\PD_Gazebo_Data_170627\ima_0_pose.csv',2);
ima0 = data0(:,7:9);
ima0(:,1) = ima0(:,1)-ima0(1,1);

data1 = csvread('bags\PD_Gazebo_Data_170627\ima_1_pose.csv',2);
ima1 = data1(:,7:9);
ima1(:,1) = ima1(:,1)-ima1(1,1);

data2 = csvread('bags\PD_Gazebo_Data_170627\ima_2_pose.csv',2);
ima2 = data2(:,7:9);
ima2(:,1) = ima2(:,1)-ima2(1,1);

data3 = csvread('bags\PD_Gazebo_Data_170627\ima_3_pose.csv',2);
ima3 = data3(:,7:9);
ima3(:,1) = ima3(:,1)-ima3(1,1);

ima_xyz = [ima0;ima1;ima2;ima3];
ima_ptCloud = pointCloud(ima_xyz);

figure
pcshow(ima_ptCloud)
title('IMA')

t0 = data0(1,1);
tEnd = data0(end,1);

data0 = csvread('bags\PD_Gazebo_Data_170627\od1_0_pose.csv',2);
[r1,~] = find(data0(:,1) > t0);
[r2,~] = find(data0(:,1) < tEnd);
%pipeData0 = data0(r(r1(end))+1:r(r1(end)+1),:);
pipeData0 = data0(r1(1):r2(end)-100,:);
od0 = pipeData0(:,7:9);
od0(:,1) = od0(:,1)-od0(1,1);

data1 = csvread('bags\PD_Gazebo_Data_170627\od1_1_pose.csv',2);
%[r,c] = find(abs(data1) == inf);
%[r1,~] = find(r < 200000);
[r1,~] = find(data0(:,1) > t0);
[r2,~] = find(data0(:,1) < tEnd);
pipeData1 = data1(r1(1):r2(end)-100,:);
od1 = pipeData1(:,7:9);
od1(:,1) = od1(:,1)-od1(1,1);

od1_xyz = [od0;od1];
od1_ptCloud = pointCloud(od1_xyz);

figure
pcshow(od1_ptCloud)
title('OD1')

save('bags\sim_clouds.mat', 'od0', 'od1','ima0','ima1','ima2', 'ima3')