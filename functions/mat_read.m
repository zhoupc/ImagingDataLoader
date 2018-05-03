function imData = mat_read(path_to_file, t_range, r_range, c_range)
%% load matfile given the frame ranges & FOV locations. The data was a 3D array (x * y * t)
%% inputs: 
%   t_range: [t_begin, t_end]
%   r_range: [r_begin, r_end]
%   c_range: 
data = matfile(path_to_file);
data_info = whos(data);

if length(data_info)>1
    imData = data.Y(r_range(1):r_range(2), c_range(1):c_range(2),...
        t_range(1):t_range(2));
else
    imData = eval(sprintf(...
        'data.%s(r_range(1):r_range(2), c_range(1):c_range(2), t_range(1):t_range(2))',...
        data_info.name));
end