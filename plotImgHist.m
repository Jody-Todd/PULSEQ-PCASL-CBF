function plotImgHist(image_dir, max)
% This function plots a few slices of a nifti image for QC and a histogram
% of the intensities. 
%
% Parameters:
%   image_dir: path to image to plot
%   max:    the maximum value for the color bar in the QC image. Default
%           value for max is 120 assuming the img to plot is a CBF map.
%           
%

addpath('/home/jtodd47/ebip_share/jtodd/matlab/slice_overlay');
addpath('/home/jtodd47/ebip_share/jtodd/matlab/spm12');

if nargin == 1
    max = 120;
end


h=figure;
set(h, 'Visible', 'off');
clear global SO;
global SO;
SO.img(1).vol = spm_vol(image_dir);
SO.img(1).range = [0 max];
SO.img(1).prop = Inf;
SO.img(1).cmap = jet;
SO.cbar = 1;
SO.transform = 'axial';
SO.slices = 6:8:80;
slice_overlay;
[parent_dir, filename, ~] = fileparts(image_dir);
print(h,'-djpeg','-r150', fullfile(parent_dir, [filename, '_jet.jpg']));

%{
% plot histogram
f=figure;
set(f, 'Visible', 'off');
data = spm_read_vols(spm_vol(image_dir));

% Remove non-brain values (e.g., zero or NaN values)
data = data(~isnan(data) & data ~= 0);

histogram(data, 'BinWidth', 0.05, 'BinLimits', [0, 1]); % Adjust BinWidth or number of bins as needed
xlabel('Intensity');
ylabel('Frequency');
title('Histogram of Image Intensities');
print(f, '-djpeg', '-r150', fullfile(parent_dir, [filename, '_hist.jpg']));
%}
