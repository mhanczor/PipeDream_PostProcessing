%% Run the Volume Post Processing

%Takes in cloud data assuming that the data is in meters

clear, close all
load('bags\sim_cloud_3m.mat');

figure
hold on
plotOD = [od0; od1];
scatter3(plotOD(:,1), plotOD(:,2), plotOD(:,3), 'r');
plotIMA = [ima0; ima1; ima2; ima3];
scatter3(plotIMA(:,1), plotIMA(:,2), plotIMA(:,3), 'b');


prepODCloud = prepSensorCloud(2, od0, od1);
disp('OD1 Cloud Prepped')

prepIMACloud = prepSensorCloud(4, ima0, ima1, ima2, ima3);
disp('IMA Cloud Prepped')


%% Generated Scan
% load('odscan.mat');
% load('imascan.mat');

odmini = {od0, od1};
ima = {ima0, ima1, ima2, ima3};

prepODCloud = prepSensorCloud(2, odmini);
disp('OD1 Cloud Prepped')

prepIMACloud = prepSensorCloud(4, ima);
disp('IMA Cloud Prepped')


%% Run the volume calculation
volume = volumeFromPtClouds(prepODCloud, prepIMACloud, true);

