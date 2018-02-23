%% Create a cube

cloud = [0, 0, 0;
        1, 0, 0;
        0, 1, 0;
        1, 1, 0;
        0, 0, 1;
        1, 0, 1;
        0, 1, 1;
        1, 1, 1];
    
scatter3(cloud(:,1), cloud(:,2), cloud(:,3));

tri_list = [2, 1, 3;
            3, 4, 2;
            5, 6, 7;
            8, 7, 6;
            1, 2, 5;
            6, 5, 2;
            3, 7, 4;
            8, 4, 7;
            1, 5, 3;
            7, 3, 5;
            2, 4, 6;
            8, 6, 4];

trisurf(tri_list, cloud(:,1), cloud(:,2), cloud(:,3));         


volume = tetVolume(cloud, tri_list, [71,3,3]);

true_vol = 1;
error = true_vol - volume
per_error = 100 * error/true_vol
