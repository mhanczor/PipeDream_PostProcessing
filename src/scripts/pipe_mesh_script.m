c1_sz = size(cloud_1,1);
c2_sz = size(cloud_2,1);

num_sensors = 2;

cloud = [cloud_1; cloud_2];

od1_sz1 = size(cloud_1(1:end-(samp_freq/(rotation_freq*2)),:), 1);
od1_sz2 = size(cloud_1(1+(samp_freq/(rotation_freq*2)):1:end,:), 1);
od2_sz1 = size(cloud_2(1+(samp_freq/(rotation_freq*2)):1:end,:),1);
od2_sz2 = size(cloud_2(1:end-(samp_freq/(rotation_freq*2)),:), 1);

tri_list1 = fringe_triangulation(cloud, od1_sz1, od2_sz1, 1, 1 + size(cloud_1,1)+(samp_freq/(rotation_freq*2)));
tri_list2 = fringe_triangulation(cloud, od2_sz2, od1_sz2, 1 + size(cloud_1,1), 1+(samp_freq/(rotation_freq*2)));
tri_list = [tri_list1; tri_list2];



trisurf(tri_list, cloud(:,1), cloud(:,2), cloud(:,3))