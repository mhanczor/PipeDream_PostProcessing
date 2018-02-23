function [] = csvWriteWithHeader( file_path, unitVolData, calcdVolData)
%CSVWRITEWITHHEADER Summary of this function goes here
%   Detailed explanation goes here

    header = {'Start Location', 'End Location', 'Volume', 'Volume/ft'};
    header = strjoin(header, ',');
    
        
    try
        file_name = [file_path '/volume.csv'];
        fid = fopen(file_name,'w');
        fprintf(fid, '%s\n', header);
        fclose(fid);
        dlmwrite(file_name, unitVolData,'-append');

        csvwrite([file_path '/volume_debug.csv'], calcdVolData);
    catch
        warning('Could not save to the desired path, file saved to the current directory')
        
        file_name = '/volume.csv';
        fid = fopen(file_name,'w');
        fprintf(fid, '%s\n', header);
        fclose(fid);
        dlmwrite(file_name, unitVolData,'-append');
        
        
        csvwrite('volume_debug.csv', calcdVolData);
    end

end

