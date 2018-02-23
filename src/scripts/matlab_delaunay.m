%% Delaunay fit
% Expect a pointcloud called pt_cloud

tri = delaunayTriangulation(pt_cloud);
tetramesh(tri);


%% Polyfit
x = pt_cloud(:,1);
y = pt_cloud(:,2);
z = pt_cloud(:,3);


T = table(x,y,z);

f = fit([T.x, T.y],T.z,'poly23');
plot( f, [T.x, T.y], T.z )