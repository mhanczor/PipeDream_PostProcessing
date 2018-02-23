function [ filteredSensor ] = sensorFilter( sensorData, direction )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%Convert the points into r^2 and n*pi measurements (1d signal)
%can use other function to bring it to 2.5d and then follow each point
%looking for a change to make it along n*pi

%Threshold to get rid of points larger than a 31" pipe?

%Filter out out of range values for the OD mini (above some high number,
%17" radius in this case)
%Threshold filter
sensorData(sensorData(:,3) > (0.4318^2),:) = [];


n = 0;
sData = sensorData;


%Unwrap the sensor measurement into a line, a 1D signal
for i = 2:size(sensorData,1)
    
    %check to see if a points went from the range -pi/0 to pi/0 and if
    %so, add transition points
    if sensorData(i-1,1) < 0 && sensorData(i,1) > 0 && strcmp(direction, 'CW')
        %Then there has been a transition in the CW direction
        n = n+1;
    elseif sensorData(i-1,1) > 0 && sensorData(i,1) < 0 && strcmp(direction, 'CCW')
        %Then there has been a transition in the CCW direction
        n = n+1;
    end
    
    
    if strcmp(direction, 'CW')
        sData(i,1) = sensorData(i,1) - 2*pi*n;
    else
        sData(i,1) = sensorData(i,1) + 2*pi*n;
    end
    
end

if strcmp(direction, 'CW')
    sData(:,1) = sData(:,1) * -1;
end

%Apply a hampel filter to remove outliers (only a 1d filter though)
sigma = 5;
%Set different parameters for the ima vs the odmini
[filteredSensor, nfilt, xmed, xstd] = hampel(sData(:,3),5, sigma);
nfiltsize = sum(nfilt);
per = nfiltsize/size(sensorData,1);
% figure
% hold on
% scatter(sData(:,1), sensorData(:,3),'r');
% scatter(sData(:,1), filteredSensor,'g');

filteredSensor = [sensorData(:,1:2), filteredSensor];

end

