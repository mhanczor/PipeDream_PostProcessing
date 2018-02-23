bagname = '../VibTests/rplidarVibTests/odmini_rplidarON_10rpm_NOmovement_IP_2017-08-02-14-30-43.bag';
bag = rosbag(bagname);
% %OD0 is the changing ODmini in these tests
od0_select = select(bag, 'Topic', '/od1_0/values');
ts = timeseries(od0_select);

% od0 = readMessages(od0_select, [1,od0_select.NumMessages]);
% 
% od1_select = select(bag, 'Topic', '/od1_1/values');


