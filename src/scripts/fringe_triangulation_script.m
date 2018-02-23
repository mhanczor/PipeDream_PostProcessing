%% Finge Triangulation

%End the first cloud a half rotation back to match the second
sen_1 = cloud_1(1:end-(samp_freq/(rotation_freq*2)), :);
%Add index numbers to this so it's easier to keep track
%sen_1 = [sen_1, 1:1:size(sen_1,1)];

%Start the second cloud a half rotation ahead to match the first
sen_2 = cloud_2(1+(samp_freq/(rotation_freq*2)):1:end, :);
%sen_2 = [sen_2, 1:1:size(sen_2,1)];

%Cloud with the data from both sensors
cloud = [sen_1; sen_2];

%For now have them both start at the same location, a prepicked closest
%point, later on this may be done by a function ahead of time or done here
p_sz = size(sen_1,1);
q_sz = p_sz + size(sen_2,1);

p_cur = 1;
q_cur = p_cur + p_sz;



%Store all the points (three points each for the vertices in order) in a
%list
tri_list = zeros(q_sz - 2, 3);

%index value
w_i = 1;
while true

    if (p_cur >= p_sz) && (q_cur >= q_sz)
        break;
    end
    
    %Create a freakin distance function duh (make it the squared norm not
    %the sqrt norm)
    
    %Right now I'm using length for laziness, use ratio after
    if pdist([cloud(p_cur,:); cloud(q_cur + 1, :)]) < pdist([cloud(p_cur+1,:); cloud(q_cur, :)])
        tri_list(w_i, :) = [p_cur, q_cur + 1, q_cur];
        if q_cur < q_sz
            q_cur = q_cur + 1;
        end
    else
        tri_list(w_i, :) = [p_cur, p_cur + 1, q_cur];
        if p_cur < p_sz
            p_cur = p_cur + 1;
        end
        
    end

    w_i = w_i + 1;
end

disp('done dozer')





%% Display mesh

trisurf(tri_list, cloud(:,1), cloud(:,2), cloud(:,3))


