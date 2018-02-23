function [ fullCloud ] = prepSensorCloud( n_sensors,  sensorData, rotDir)
%Takes in a number of the same sensors and processes them into a single
%cloud

fullCloud = [];

if n_sensors ~= length(sensorData)
    error('Not enough inputs');
end

%Process each sensor input
for i = 1:n_sensors
    
    %Move the cloud to 2.5D, squared the radius at this point for direct
    %volume calculation
    redCloud = cart2pol(sensorData{i});

    %Filter each individual sensor
    redCloud = sensorFilter(redCloud, rotDir);
    
    %Add transition points to span the cloud from -pi to pi
    redCloud = addTransitionPoints(redCloud, rotDir);
              
    fullCloud = [fullCloud; redCloud]; 
end





end

