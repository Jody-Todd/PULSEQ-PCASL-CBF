function plot_motion(rp_file, asl_tools)
% This function expects a rp_*.txt file from spm_realign where the first 3 
% columns are x,y,z translations in mm and the second 3 columns are roll,
% pitch, yaw in rad. If ASL Toolbox was used to generate the rp_*.txt file, 
% then there wil be 12 columns instead of 6. In this case the last 6 columns 
% will be used since these are the cleaned motion parameters. 

% Parameters:
%   rp_file: rp_*.txt file containing realignment parameters from spm_realign or similar function. 
%
%   asl_tools: boolean variable indicating whether asl_tools.m was used to generate the rp_*.txt file. True by default. 
%
%

    if nargin < 2
        asl_tools = true;
    end

    assert(islogical(asl_tools) && isscalar(asl_tools), 'asl_tools must be a boolean value: true or false');

    motion_params = load(rp_file); 

    if asl_tools
        disp('Using last 6 columns of rp_*.txt file from ASL Toolbox realignment');
        motion_params = motion_params(:,7:end); % columns 7:end are the cleaned motion parameters from asl toolbox
	filename = 'cleaned_motion.png';
    else
        disp("asl_tools='false'. Using first 6 columns of rp_*.txt file");
        motion_params = motion_params(:,1:6);
	filename = 'orig_motion.png';
    end

    % convert rotations to degrees
    motion_params(:,4:end) = motion_params(:,4:end)*180/pi;
  
    % Plot the translations (first 3 columns)
    figure;
    subplot(2,1,1);  % Create subplot for translations
    plot(motion_params(:, 1:3));
    title('Translations');
    xlabel('Volume');
    ylabel('Translation (mm)');
    legend('dS', 'dL', 'dP');
    xticks(0:25:size(motion_params, 1));

    
    % Plot the rotations (last 3 columns)
    subplot(2,1,2);  % Create subplot for rotations
    plot(motion_params(:, 4:6));
    title('Rotations');
    xlabel('Volume');
    ylabel('Rotation (degrees)');
    legend('roll', 'pitch', 'yaw');
    xticks(0:25:size(motion_params, 1));


    [path, ~, ~] = fileparts(rp_file);
    saveas(gcf, [path, filesep, filename]);

end
