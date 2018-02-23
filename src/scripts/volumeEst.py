import subprocess

proc_name = "matlab -nosplash -nodesktop -nojvm -r \"cd('~/PipeDream/Post-Processing/Matlab/volume_estimation');try warning('off', 'MATLAB:delaunay:DupPtsDelaunayWarnID');warning('off', 'VolEst:SurfaceCheck'); pipeVol = volumePostProcessing('../bags/2017-07-12-20-39-07', 4, 2, 0.5, false, 3, 4.5);disp(pipeVol); catch disp('Something went wrong'); exit(1); end;  quit\""

# p = subprocess.Popen("/home/hades/PipeDream/Post-Processing/Matlab/scripts/volume_estimation.sh", stdout = subprocess.PIPE, shell=True)
p = subprocess.Popen(proc_name, stdout = subprocess.PIPE, shell=True)


(output, err) = p.communicate()

p_status = p.wait()

print output
print "Command exit status/return code: ", p_status
