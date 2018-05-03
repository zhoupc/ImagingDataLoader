function imData = hdf5_read(path_to_file, t_range, r_range, c_range)
%% load hdf5 given the frame ranges & FOV locations. The data was a 3D array (x * y * t)
%% inputs:
%   t_range: [t_begin, t_end]
%   r_range: [r_begin, r_end]
%   c_range: [c_begin, r_end]
info = hdf5info(path_to_file);

idx_0 = [r_range(1), c_range(1), t_range(1)];
n_read = [diff(r_range), diff(c_range), diff(t_range)]+1;
imData =squeeze( h5read(path_to_file,info.GroupHierarchy.Datasets.Name,...
    idx_0,n_read));
