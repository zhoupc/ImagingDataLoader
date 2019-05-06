function imData = mat4d_read(path_to_file, t_range, z_range, r_range, c_range)
%% load matfile given the frame ranges & FOV locations. The data was a 3D array (x * y * t)
%% inputs: 
%   t_range: [t_begin, t_end]
%   z_range: [z_begin, z_end]
%   r_range: [r_begin, r_end]
%   c_range: 
data = matfile(path_to_file);
data_info = whos(data);
dims = data_info.size; 

if diff(z_range)+1 == dims(3)
    z_str = ':'; 
else
    z_str = 'seq(z_range)'; 
end

if diff(r_range)+1 == dims(1)
    r_str = ':'; 
else
    r_str = 'seq(r_range)'; 
end

if diff(c_range)+1 == dims(2)
    c_str = ':'; 
else
    c_str = 'seq(c_range)'; 
end

if length(dims) < 4
    imData = eval(sprintf('data.%s(%s,%s,%s)', data_info.name, r_str, c_str, z_str));
else
    if diff(t_range)+1 == dims(4)
        t_str = ':';
    else
        t_str = 'seq(t_range)';
    end
    imData = eval(sprintf('data.%s(%s,%s,%s, %s)', data_info.name, r_str, c_str, z_str,t_str));
end