classdef IDL < handle
    
    % This class is a wrapper for partially loading 2D/3D imaging data of different
    % formats using the same interface
    
    % Author: Pengcheng Zhou, Columbia University, 2018
    % zhoupc1988@gmail.com
    
    %% properties
    properties
        vars = {};    % user defined variables for customized loading. usually this variable is a string specifying the file name.
        type = [];  % file type {'tiff', 'hdf5', 'h5', 'avi', 'mat', 'dir', 'cnmfe_mat', etc}
        fload = []; % functions for loading data. We provided support for few file types, but you can provide the customized version for your type.
        fname = @(vars, z) vars{z};
        dims = [0, 0, 1];  % dimension of data (x, y, z)
        num_frames = [];  % number of frames
        nfiles = true;    % different planes were saved into differnet files 
    end
    
    %% methods
    methods
        %% constructor
        function obj = IDL(varargin)
            %% parse input arguments
            obj.parseinputs(varargin{:});
            
            %% post-processing input arguments
            if ~iscell(obj.vars)
                obj.vars = {};
                disp('bad input for file names');
                return;
            elseif length(obj.vars)==1
                [~, ~, temp] = fileparts(obj.vars{1});
                if isempty(temp)
                    type_default = 'dir'; % the images were saved as image sequences in a folder
                else
                    type_default = temp(2:end);
                end
                if isempty(obj.type)
                    obj.type = type_default;
                end
            end
            
            %loading function
            if isempty(obj.fload) && ~isempty(obj.type)
                obj.fload = obj.determine_loading_fun();
            end
            
        end
        
        %% deterime the loading function
        function load_fun = determine_loading_fun(obj)
            switch lower(obj.type)
                case {'tiff', 'tif', 'btf'}
                    load_fun = @tiff_read;
                case {'mat', '.mat'}
                    load_fun = @mat_read;
                case 'cnmfe_mat'
                    load_fun = @bigread2;
                case {'hdf5', 'h5'}
                    load_fun = @hdf5_read; 
                case {'avi', '.avi'}
                    load_fun = @avi_read; 
                case {'npy', '.npy'}
                    load_fun = @npy_read; 
                otherwise
                    load_fun = [];
                    warning('not specified yet');
            end
        end
        
        %% load data with the dimension
        function imData = load_tzrc(obj, t_range, z_range, r_range, c_range)
            %% load a video for a 2D or 3D data
            %% parse input arguments
            if ~exist('r_range', 'var') || isempty(r_range)  % load single plane
                r_range = [1, obj.dims(1)];
            end
            if ~exist('c_range', 'var') || isempty(c_range)  % load single plane
                c_range = [1, obj.dims(2)];
            end
            if ~exist('z_range', 'var') || isempty(z_range)  % load single plane
                z_range = [1, obj.dims(3)];
            elseif length(z_range) ==1
                z_range = ones(1,2) * z_range; 
            end
            if ~exist('t_range', 'var') || isempty(z_range)
                t_range = [1, obj.num_frames]; 
            end
            
            T = diff(t_range) + 1;
            nz = diff(z_range) + 1;
            nr = diff(r_range) + 1;
            nc = diff(c_range) + 1;
            
            %% load data
            if obj.nfiles 
                % multiple plane data were saved into multiple files 
                if nz == 1  % single plane 
                    filename = obj.get_fn(z_range(1));
                    imData = obj.fload(filename, t_range, r_range, c_range);
                else        % multiple planes
                    imData = cell(nz, 1);
                    for m=1:nz
                        filename = obj.get_fn(z_range(1)+m-1);
                        imData{m} = reshape(obj.fload(filename, t_range, r_range, c_range),...
                            nr*nc, T);
                    end
                    imData = reshape(cell2mat(imData), nr, nc, nz, T);
                end
            else
                % a single file containing all data
                filename = obj.get_fn(1); 
                imData = obj.fload(filename, t_range, z_range, r_range, c_range);
            end
            
        end
        
        %% parse inputs
        function parseinputs(obj, varargin)
            %% parse all input arguments
            k = 1;
            while k<=nargin-1
                if isempty(varargin{k})
                    k = k+1;
                end
                switch lower(varargin{k})
                    case {'vars', 'filenames', 'files'}
                        % varialbes relating to file names or list of
                        % filenames
                        k = k + 1;
                        temp = varargin{k};
                        if ischar(temp)
                            obj.vars = {temp};
                            obj.dims(3) = 1;
                        elseif iscell(temp)
                            obj.vars = temp;
                        else
                            k = k-1;
                        end
                        k = k + 1;
                    case 'type'
                        obj.type = varargin{k+1};
                        k = k+2;
                    case 'fload'
                        obj.fload = varargin{k+1};
                        k = k+2;
                    case 'fname'
                        obj.fname = varargin{k+1};
                        k = k+2;
                    case 'dims'
                        temp = reshape(varargin{k+1}, 1, []);
                        if length(temp)==2
                            temp(3) = 1;
                        end
                        obj.dims = temp(1:3);
                        k = k+2;
                    case {'t', 'num_frames'}
                        obj.num_frames = varargin{k+1};
                        k = k + 2;
                    otherwise
                        k = k+1;
                end
            end
        end
        
        %% get file name given the plane id 
        function filename = get_fn(obj, z)
           filename = obj.fname(obj.vars, z);
        end
    end
end
