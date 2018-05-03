temp = which('IDL.m');
IDL_folder = temp(1:strfind(temp, '@IDL')-1);
data_folder = fullfile(IDL_folder, 'demos', 'data');
if ~exist('demo_data', 'var')
    load(fullfile(IDL_folder, 'demos', 'data', 'demo_data.mat'));
    temp = size(demo_data);
    dims = temp(1:3);
    num_frames = temp(4);
end

clear Y_all Y_part; 
test_format = 'tif';   % supported formats: {mat, hdf5, tif, avi, npy}

%%
switch lower(test_format)
    case 'hdf5'
        vars = {fullfile(data_folder, 'h5_data_'), '.h5'};
        get_filename = @(vars, z) sprintf('%s%d%s', vars{1}, z, vars{2});
        
        if ~exist(get_filename(vars, 1), 'file')
            % create demo data
            for m=1:3
                block = squeeze(demo_data(:, :, m, :));
                fn = fullfile(data_folder, sprintf('h5_data_%d.h5',m));
                h5create(fn, '/video', [32, 32, 1000]);
                h5write(fn, '/video', block);
            end
        end
    case {'mat', '.mat'}
        vars = {fullfile(data_folder, 'mat_data_'), '.mat'};
        get_filename = @(vars, z) sprintf('%s%d%s', vars{1}, z, vars{2});
        
        if ~exist(get_filename(vars, 1), 'file')
            % create demo data
            for m=1:3
                block = squeeze(demo_data(:, :, m, :));
                fn = fullfile(data_folder, sprintf('mat_data_%d.mat',m));
                save(fn ,'block', '-v7.3');
            end
        end
    case {'tiff', '.tiff', 'tif', '.tif'}
        vars = {fullfile(data_folder, 'tif_data_'), '.tif'};
        get_filename = @(vars, z) sprintf('%s%d%s', vars{1}, z, vars{2});
        
        if ~exist(get_filename(vars, 1), 'file')
            % create demo data
            for m=1:3
                block = squeeze(demo_data(:, :, m, :));
                fn = fullfile(data_folder, sprintf('tif_data_%d.tif',m));
                saveastiff(block, fn);
            end
        end
    case {'avi', '.avi'}
        vars = {fullfile(data_folder, 'avi_data_'), '.avi'};
        get_filename = @(vars, z) sprintf('%s%d%s', vars{1}, z, vars{2});
        
        if ~exist(get_filename(vars, 1), 'file')
            % create demo data
            for m=1:3
                block = squeeze(demo_data(:, :, m, :));
                fn = fullfile(data_folder, sprintf('avi_data_%d.avi',m));
                saveasAVI(block, fn);
            end
        end
        
    case {'npy', '.npy'}
        vars = {fullfile(data_folder, 'npy_data_'), '.npy'};
        get_filename = @(vars, z) sprintf('%s%d%s', vars{1}, z, vars{2});
        
        if ~exist(get_filename(vars, 1), 'file')
            % create demo data
            for m=1:3
                block = squeeze(demo_data(:, :, m, :));
                fn = fullfile(data_folder, sprintf('npy_data_%d.npy',m));
                writeNPY(block, fn);
            end
        end
    otherwise
        disp('sorry, IDL does not support to this file format yet. ');
end

%% creating a class object
tic; 

data = IDL('vars', vars, 'fname', get_filename, 'type', test_format, 'dims', ...
    dims, 'num_frames', num_frames);

% load the whole volume
Y_all = data.load_tzrc(); 

% partially load data
t_range = [201, 300];
z_range = [2,2] ;  % single plane
r_range = [6, 20];
c_range = [11, 30];
Y_part = data.load_tzrc(t_range, z_range, r_range, c_range);

toc; 
%%
cn1 = correlation_image(squeeze(Y_all(:, :, 1, :))); 
cn_part = correlation_image(Y_part); 

figure; 
subplot(121); 
imagesc(cn1); 
axis equal off tight; 
subplot(122); 
imagesc(cn_part); 
axis equal off tight; 
%%


















