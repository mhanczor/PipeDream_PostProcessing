clc, clear, close all

data0 = csvread('~/Desktop/full_sim/ima_0_pose.csv',2);
xyz0 = data0(:,7:9);
xyz0(:,1) = xyz0(:,1)-xyz0(1,1);

data1 = csvread('~/Desktop/full_sim/ima_1_pose.csv',2);
xyz1 = data1(:,7:9);
xyz1(:,1) = xyz1(:,1)-xyz1(1,1);

data2 = csvread('~/Desktop/full_sim/ima_2_pose.csv',2);
xyz2 = data2(:,7:9);
xyz2(:,1) = xyz2(:,1)-xyz2(1,1);

data3 = csvread('~/Desktop/full_sim/ima_3_pose.csv',2);
xyz3 = data3(:,7:9);
xyz3(:,1) = xyz3(:,1)-xyz3(1,1);

ima_xyz = [xyz0;xyz1;xyz2;xyz3];
ima_ptCloud = pointCloud(ima_xyz);

figure
pcshow(ima_ptCloud)
title('IMA')

t0 = data0(1,1);
tEnd = data0(end,1);

data0 = csvread('~/Desktop/full_sim/od1_0_pose.csv',2);
[r1,~] = find(data0(:,1) > t0);
[r2,~] = find(data0(:,1) < tEnd);
%pipeData0 = data0(r(r1(end))+1:r(r1(end)+1),:);
pipeData0 = data0(r1(1):r2(end)-100,:);
xyz0 = pipeData0(:,7:9);
xyz0(:,1) = xyz0(:,1)-xyz0(1,1);

data1 = csvread('~/Desktop/full_sim/od1_1_pose.csv',2);
%[r,c] = find(abs(data1) == inf);
%[r1,~] = find(r < 200000);
[r1,~] = find(data0(:,1) > t0);
[r2,~] = find(data0(:,1) < tEnd);
pipeData1 = data1(r1(1):r2(end)-100,:);
xyz1 = pipeData1(:,7:9);
xyz1(:,1) = xyz1(:,1)-xyz1(1,1);

od1_xyz = [xyz0;xyz1];
od1_ptCloud = pointCloud(od1_xyz);

figure
pcshow(od1_ptCloud)
title('OD1')

save('sim_clouds.mat','od1_ptCloud','ima_ptCloud','od1_xyz','ima_xyz')