%% 3D coordinates to 2.5D

%Coordinates come in as x,y,z, convert to theta, z, r

radius = sqrt(cloud(:,1).^2 + cloud(:,2).^2);
r_coord = [atan2(cloud(:,2), cloud(:,1)), cloud(:,3), radius];

%Need to make sure there is some bounding on the 0 and 2pi edges so there
%is no lost volume

%% Matlab's delaunay in 2D
tri = delaunay(r_coord(:,1), r_coord(:,2));

% trimesh(tri, r_coord(:,1), r_coord(:,2));

%% Side Mesh



sideTri = sideMesh(cloud1, cloud2);

cloud = [cloud1; cloud2];
tri = [tri_cloud1; tri_cloud2 + size(cloud1, 1); sideTri];

trisurf(tri, cloud(:,1), cloud(:,2), cloud(:,3));



%% Plot
figure
scatter3(r_coord(:,1), r_coord(:,2), r_coord(:,3));

%% Plot
figure
scatter3(cloud(:,1), cloud(:,2), cloud(:,3));

%% Calculate Volume

volume = tetVolume(cloud, tri, [0,0,0]);

%% Rect test surface
cloud1 = [0, 0, 0];
for i = 1:5
    for j = 1:5
        cloud1 = [cloud1; [i, j, 4]];
    end
end
cloud1 = cloud1(2:end, :);

cloud2 = cloud1;
cloud2(:,3) = 2;

%% Rect Test Run


tri1 = delaunay(cloud1(:,1), cloud1(:,2));
tri2 = delaunay(cloud2(:,1), cloud2(:,2));
%tri2 = [tri2(:,2), tri2(:,1), tri2(:,3)];

sideTri = sideMesh(cloud1, cloud2);

cloud = [cloud1; cloud2];
tri = [tri1; tri2 + size(cloud1, 1); sideTri];

%% Plot the surface function
trisurf(tri, cloud(:,1), cloud(:,2), cloud(:,3));

%% Calculate the volume
volume = tetVolume(cloud, tri, [0,0,-5]);


%% Orient the surface normals

oriented = orientNormals(tri);
tri = oriented;


%% Test surface normals
sn = [0, 0, 0];
for i = 1:size(tri,1)
    
%     checkSurfaceNormal(cloud1([tri1(i, 1) tri1(i,2) tri1(i,3)], :))
    sn = [sn;checkSurfaceNormal(cloud([tri(i, 1) tri(i,2) tri(i,3)], :))];
    
end
sn = sn(2:end, :);



%% Add transition points to go from pi to -pi


    
