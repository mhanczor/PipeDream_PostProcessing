function [ unitVolume ] = volumePostProcessing( file_path, ima_sensors, odmini_sensors, unit_size, visualize, startPt, endPt)
%Pass in the paths of the IMA sensor readings and 
%   Inputs:
%   file_path - the path to the folder where all the sensor
%   measurements are located.  Each sensor will be in the folder labeled
%   'ima_pose_X.csv' or 'od1_pose_X.csv' where the X represents sensors 0-n
%   ima/odmini_sensors - the number of each sensor to be used, n+1
%   unit_size - the unit of length that volume will be evaluated over,
%   sections will overlap by half.  If unit_size == 0 then then entire
%   cloud will be considered.
%   visualize - T/F, turns on or off plotting of figure
%   start - start location in the pipe
%   end - end location in the pipe

%   Output:
%   Calculated Volume - matrix with the start and stop locations of the
%   evaluated section, along with the volume and volume per that unit of
%   length [startPos(m), stopPos(m), volume(m^3), volume/len(m^3/ft)]

%   This program looks at the entire point cloud and any points that are in
%   an area of interest, not contiguous points in an area

close all


imaData = {};
odminiData = {};

%Verify this rotation direction on the robot
rotDir = 'CW';

%Conversion to 1ft increments
mToFt = (1/1000)*25.4*12;

%If users want to run the whole section of pipe, set the endPt to be zero
if endPt == 0
    endPt = 10000;
end

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
%         imaTmp = imaTmp(:,7:9);
        imaTmp(imaTmp(:,1) < startPt, :) = [];
        imaTmp(imaTmp(:,1) > endPt, :) = [];
        
        imaData{i} = imaTmp;
    end
else
    error('No IMA sensors imported')
end

if odmini_sensors > 0
    for i = 1:odmini_sensors
        load_name = [file_path '/od1_' num2str(i-1) '_pose.csv'];
        
        try
            odTmp = csvread(load_name, 2);
        catch
            error('Missing ODMini sensor data to load in!')
        end
        
        odTmp= odTmp(:,6:8);
%         odTmp= odTmp(:,7:9);
        
        %Filter out points before the start and after the end
        odTmp(odTmp(:,1) < startPt,:) = [];
        odTmp(odTmp(:,1) > endPt,:) = [];
        
        odminiData{i} = odTmp;
    end
else
    error('No ODMINI sensors imported')
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

%Convert to theta, x, radius^2 coordinate system and filter points
prepODCloud = prepSensorCloud(odmini_sensors, odminiData, rotDir);
disp('OD1 Cloud Prepped')

prepIMACloud = prepSensorCloud(ima_sensors, imaData, rotDir);
disp('IMA Cloud Prepped')

%Make sure the actual clouds are within the user specified start and end
%pts
if min([min(prepIMACloud(:,2)), min(prepODCloud(:,2))]) > startPt
    startPt = min([min(prepIMACloud(:,2)), min(prepODCloud(:,2))]);
end

if max([max(prepIMACloud(:,2)), max(prepODCloud(:,2))]) < endPt
    endPt = max([max(prepIMACloud(:,2)), max(prepODCloud(:,2))]);
end

curStart = startPt;
curEnd = startPt + unit_size;
    
if abs(prepODCloud(1,2) - prepIMACloud(1,2)) >  0.010
    error('Starting offset between IMA and ODMini is too large!')
end

%This checks to see if the data is collected moving forward in the x
%direction or backwards.  Should have something more sophisticated
if abs(curStart - prepODCloud(1,2)) > 0.010
    error('Data direction error')
end

calcdVolume = [];
stopTag = false;
iter = 0;
while ~stopTag
    
    if curStart + unit_size > endPt
        curEnd = endPt;
        stopTag = true;
    end
    
    %Take the full size cloud and trim it to be within the bounds of the
    %start and end points.  Include 31mm max forward and backward for start
    %and end interpolation
    buf = 0.07;
    if curStart - buf >= startPt
        startAdj = buf;
    else
        startAdj = 0.0;
    end
    
    if curEnd + buf <= endPt
        endAdj = buf;
    else
        endAdj = 0.0;
    end
    
    %For the IMA and ODMini, set the points to be within the current
    %evaluation bound.
    curODCloud = prepODCloud(prepODCloud(:,2) >= curStart - startAdj,:);
    curODCloud = curODCloud(curODCloud(:,2) <= curEnd + endAdj,:);
    
    curIMACloud = prepIMACloud(prepIMACloud(:,2) >= curStart - startAdj,:);
    curIMACloud = curIMACloud(curIMACloud(:,2) <= curEnd + endAdj,:);
    
    
    c1_check = curODCloud(curODCloud(:,2) >= curStart,:);
    c1_check = c1_check(c1_check(:,2) <= curEnd,:);
    
    c2_check = curIMACloud(curIMACloud(:,2) >= curStart,:);
    c2_check = c2_check(c2_check(:,2) <= curEnd,:);
    
  
    %Check to see if either clouds are empty or are very sparse
    if isempty(c1_check) || isempty(c2_check)
        warning('Missing data from this section, skipped!')
        fprintf('Finished with section %f to %f ', curStart, curEnd)
        volume = inf;
    else
        %Return the volume of the current evaluation section.
        volume = volumeFromPtClouds(curODCloud, curIMACloud, visualize, curStart, curEnd);
    end
    
    len = abs(curEnd - curStart);
    if volume < 0
        warning('Negative volume calculated')
        volume = abs(volume);
    end
    
    %Convert to mm
    volume = volume*1000^3;
    
    %Store the section start, end, volume over the length of the section,
    %and volume per unit of evaluation (v/ft)
    calcdVolume = [calcdVolume; curStart, curEnd, volume, mToFt*volume/len];
    
    fprintf('Finished with section %f to %f ', curStart, curEnd)
    
    if visualize
        f = warndlg('Close to keep running', 'Close to Run');
        drawnow
        waitfor(f)
        close all 
    end
    
    %Increase by half the distance of the evaluation length so there is 50%
    %overlap
    curStart = curStart + unit_size/2.0;
    curEnd = curStart + unit_size;
    iter = iter + 1;
end

disp('Start Point, End Point, Volume(m^3/len), Volume(m^3/ft)')

unitVolume=[];

if size(calcdVolume,1) > 1
    %Loop up to the number of steps unless you finish on a half step
    for i = 1:2:(iter-1+mod(iter,2))
        if i == 1
            unitVolume = [calcdVolume(1,1:3), max(calcdVolume(i:i+1,4))];
        elseif i+1 > size(calcdVolume, 1)
            unitVolume = [unitVolume; calcdVolume(i,1:3), max(calcdVolume(i-1:i,4))];
        else
            unitVolume = [unitVolume; calcdVolume(i,1:3), max(calcdVolume(i-1:i+1,4))];
        end
        
        %This is if you end on a half-step, need to handle
        if i+1 == size(calcdVolume,1) 
            unitVolume = [unitVolume; calcdVolume(i,2), calcdVolume(i+1,2:4)];
        end
    end
    
elseif size(calcdVolume,1) == 1
    unitVolume = calcdVolume(1,1:4);
else
    warning('Unable to process the data');
end
    
    
%Save the data with a header
csvWriteWithHeader(file_path, unitVolume, calcdVolume)

end

