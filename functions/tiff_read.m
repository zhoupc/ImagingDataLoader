function imData = tiff_read(path_to_file, t_range, r_range, c_range)
%% load Tiff file given the frame ranges & FOV locations. The data was a 3D array (x * y * t)
%% inputs:
%   t_range: [t_begin, t_end]
%   r_range: [r_begin, r_end]
%   c_range: [c_begin, r_end]

imData = smod_bigread2(path_to_file, t_range(1), diff(t_range)+1);

imData = imData(r_range(1):r_range(2), c_range(1):c_range(2), :); 
