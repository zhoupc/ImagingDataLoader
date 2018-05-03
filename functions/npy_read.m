function imData = npy_read(path_to_file, t_range, r_range, c_range)
%% load matfile given the frame ranges & FOV locations. The data was a 3D array (x * y * t)
%% inputs:
%   t_range: [t_begin, t_end]
%   r_range: [r_begin, r_end]
%   c_range:

% Function to read NPY files into matlab.
% *** Only reads a subset of all possible NPY files, specifically N-D arrays of certain data types.
% See https://github.com/kwikteam/npy-matlab/blob/master/npy.ipynb for
% more.
%

[shape, dataType, fortranOrder, ~, totalHeaderLength, ~] = ...
    readNPYheader(path_to_file);

if fortranOrder
    % [r, c, t]
    mmap = memmapfile(path_to_file, 'Offset', totalHeaderLength, ...
        'Format', {dataType, shape, 'Y'});
    if prod(shape)==r_range(2) * c_range(2) * t_range(2)
        imData = mmap.Data.Y;
    else
        imData = mmap.Data.Y(seq(r_range), seq(c_range), seq(t_range));
    end
else
    % [t, c, r]
    mmap = memmapfile(path_to_file, 'Offset', totalHeaderLength, ...
        'Format', {dataType, shape(end:-1:1), 'Y'});
    if prod(shape)==r_range(2) * c_range(2) * t_range(2)
        imData = permute(mmap.Data.Y, [3, 2, 1]);
    else
        imData = permute(mmap.Data.Y(seq(t_range),...
            seq(c_range), seq(r_range)), [3, 2, 1]);
    end
end
