function plotQCResults(image_dir)

addpath('/home/jtodd47/ebip_share/jtodd/matlab/slice_overlay');
addpath('/home/jtodd47/ebip_share/jtodd/matlab/spm12');

h=figure;
set(h, 'Visible', 'off');
clear global SO;
global SO;
SO.img(1).vol = spm_vol(image_dir);
SO.img(1).range = [0 120];
SO.img(1).prop = Inf;
SO.img(1).cmap = gray;
SO.cbar = 1;
SO.transform = 'axial';
%SO.slices = -30:6:24;

% Get bounding box in mm
V = spm_vol(image_dir);
bb = spm_get_bbox(V);   % 2x3 matrix [xmin ymin zmin; xmax ymax zmax]
zmin = bb(1,3);
zmax = bb(2,3);

% Sample every slice (voxel spacing in z direction = V.mat(3,3))
zstep = abs(V.mat(3,3));
SO.slices = zmin:zstep:zmax;

slice_overlay;
[parent_dir, filename, ~]  = fileparts(image_dir);
print(h,'-djpeg','-r150',fullfile(parent_dir, [filename, '_gray_QC.jpg']));
