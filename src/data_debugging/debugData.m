function [ output_args ] = debugData( file_path, ima_sensors, odmini_sensors )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

close all

visualize = false;

imaData = {};
imaUW = {};
odminiData = {};
odminiUW={};
odminiValues = {};

%Verify this rotation direction on the robot
rotDir = 'CW';

%Conversion to 1ft increments
mToFt = (1/1000)*25.4*12;

%Load in the sensor data

if ima_sensors > 0
    for i = 1:ima_sensors
        load_name = [file_path '/ima_' num2str(i-1) '_pose.csv'];
        
        try
            imaTmp = csvread(load_name, 2);
        catch
            error('Missing IMA sensor data to load in!')
        end
        
        imaTmp = imaTmp(:,6:8);
        
        %imaT2 = cart2pol(imaTmp);
        %imaT2(imaT2(:,3) > 0.4, :) = [];
        imaUW{i} = cart2pol(imaTmp);
        imaData{i} = imaTmp;
    end
end


if odmini_sensors > 0
    for i = 1:odmini_sensors
        load_name = [file_path '/od1_' num2str(i-1) '_pose.csv'];
        
        try
            odTmp = csvread(load_name, 2);
            odTmp= odTmp(:,6:8);
        
            odT2 = cart2pol(odTmp);
            odT2(odT2(:,3) > 0.4, :) = [];
            odminiUW{i} = cart2pol(odTmp);

            odminiData{i} = odTmp;
        catch
            warning('Missing ODMini sensor data to load in!')
        end
        
        
        
        %Bring in the ODMini Values
        load_name = [file_path '/od1_' num2str(i-1) '_values.csv'];
        try
            odVal = csvread(load_name, 2);
        catch
            error('Missing ODMini sensor data to load in!')
        end
        
        odVal = odVal(:,8);
        odVal = odVal/100;
        odminiValues{i} = odVal;
        
    end
end


disp('Sensor data loaded')


%Plots the data for the whole length of pipe specified by the start and end pts
%ODmini data is in red, IMA data is in blue
if visualize
    figure('Name', 'Entire Pipe Length Point Clouds')
    hold on
    plotOD = [];
        for i = 1:size(odminiData,2)
            plotOD = [plotOD; odminiData{i}];
        end
    
    plotIMA = [];
        for i = 1:size(odminiData,2)
            plotIMA = [plotIMA; imaData{i}];
        end
        
    scatter3(plotOD(:,1), plotOD(:,2), plotOD(:,3), 'r');
    scatter3(plotIMA(:,1), plotIMA(:,2), plotIMA(:,3), 'b');
end


%Plot the IMA's
figure('Name','IMA Unwrapped')
hold on
for i = 1:length(imaUW)
    scatter(imaUW{i}(:,1), sqrt(imaUW{i}(:,3)), '.')
end

figure('Name','ODMini Undwrapped')
hold on
for i = 1:length(odminiUW)
    scatter(odminiUW{i}(:,1), sqrt(odminiUW{i}(:,3)), '.')
end

shift = 1;

figure('Name','ODMini 1D')
hold on
for i = 1:length(odminiValues)
    start = 1;
    if i == 2
        start = shift;
    end
    scatter(start:length(odminiValues{i})+start - 1, odminiValues{i}, '.')
end

shift1 = odminiValues{1};
shift2 = odminiValues{2} + shift;

shift1 = shift1(shift:end,:);
shift2 = shift2(1:size(shift1,1),:);



diff = [shift1 - shift2, length(shift1)];
diff(diff(:,1),:) = [];
figure('Name', 'ODMini Diff')
plot(1:length(diff), diff, '.')

end

