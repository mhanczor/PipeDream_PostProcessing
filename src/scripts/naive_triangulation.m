%% Naive Triangulation

%End the first cloud a half rotation back to match the second
sen_1 = cloud_1(1:end-(samp_freq/(rotation_freq*2)), :);
%Start the second cloud a half rotation ahead to match the first
sen_2 = cloud_2(1+(samp_freq/(rotation_freq*2)):1:end, :);

s1_end = size(sen_1, 1);
tri_end = size(sen_1,1) + size(sen_2,1);

tri = [(1:s1_end-1)', (2:s1_end)', (s1_end+1:tri_end-1)';
        (s1_end+1:tri_end-1)', (s1_end+2:tri_end)', (2:s1_end)';
        ];

full_sen = [sen_1; sen_2];


trisurf(tri, full_sen(:,1), full_sen(:,2), full_sen(:,3));
