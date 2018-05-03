IDL_folder = fileparts(mfilename('fullpath')); 
addpath(IDL_folder); 

% functions written for IDL 
addpath(fullfile(IDL_folder, 'functions'));


% packages copied from other packages 
IDL_packages = fullfile(IDL_folder, 'packages'); 
addpath(fullfile(IDL_packages, 'saveastiff')); 
addpath(fullfile(IDL_packages, 'npy-matlab')); 
addpath(fullfile(IDL_packages, 'TIFFStack')); 

%% save the current path 
%savepath(); 
