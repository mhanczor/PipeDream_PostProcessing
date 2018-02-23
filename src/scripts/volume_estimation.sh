matlab -nosplash -nodesktop -nojvm -r "cd('~/PipeDream/Post-Processing/Matlab/volume_estimation');try warning('off', 'MATLAB:delaunay:DupPtsDelaunayWarnID');warning('off', 'VolEst:SurfaceCheck'); pipeVol = volumePostProcessing('../bags/2017-07-12-20-39-07', 4, 2, 0.5, false, 3, 4.5);disp(pipeVol); catch disp('Something went wrong'); exit(1); end;  quit"

