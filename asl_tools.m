function asl_tools(img_path,s)
% realign and filter motion from ASL timeseries using the asl toolbox
%
% Parameters:
%	img_path: absolute path of images to realign


% load spm defaults
global defaults;
spm_get_defaults;

% Get realignment defaults
defs = defaults.realign;

[path, filename, ext] = fileparts(img_path);

% set spm realign flags
reaFlags = struct(...
    'quality', 1,...  			  % estimation quality
    'fwhm', 3,...                         % smooth before calculation
    'rtm', 1,...                          % whether to realign to mean
    'PW',''...                            %
    );


% set spm reslice flags
resFlags = struct(...
    'interp', 3,...                       % cubic interpolation
    'wrap', defs.write.wrap,...           % wrapping info (ignore...)
    'mask', defs.write.mask,...           % masking (see spm_reslice)
    'which',2,...                         % write reslice time series for all images
    'mean',1);                            % do write mean image

% perform asl realignment
spm_realign_asl(img_path, reaFlags);
spm_reslice(img_path, resFlags); % outputs recho1.nii

% smooth asl data with fwhm s
ASLtbx_smoothing(fullfile(path, ['r', filename, ext]), s); % outputs srecho1.nii

% compute cbf on smoothed data
%environment_config();
%para = get_parameter(path, 0); 
%compute_cbf(para, fullfile(path, 'srecho1.nii'));


