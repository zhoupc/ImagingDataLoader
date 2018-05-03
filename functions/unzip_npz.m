function unzip_npz(fn)
%% unzip npz file into 1 or multiple npy files; use the npz file as a prefix of all npy files

[folder, fnpz, ext]  = fileparts(get_fullname(fn));


if isempty(ext)
    fprintf('unzip folder %s\n', fullfile(folder, fnpz));
    temp = dir(fullfile(folder, fnpz, '*.npz'));
    for m=1:length(temp)
        unzip_npz(fullfile(temp(m).folder, temp(m).name));
    end
elseif strcmpi(ext, '.npz')
    fprintf('    unzip file %s%s\n', fnpz, ext);
    
    % folder for saving results
    npz_folder = fullfile(folder, fnpz);
    mkdir(npz_folder);
    
    % unzip
    unzip(fn, npz_folder);
    
    % list all files within the unziped folder
    temp = dir(fullfile(npz_folder, '*.npy'));
    
    for m=1:length(temp)
        movefile(fullfile(npz_folder, temp(m).name), fullfile(folder, [fnpz,'_', temp(m).name]));
    end
    
    rmdir(npz_folder, 's');
    
else
    disp('wrong input arguments.');
end