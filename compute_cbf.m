function compute_cbf(para, asl_timeseries) %TR, MB_factor, tau, PLD, PreLD )
% Currently, this script works for multi-echo single slice data only. If you acquire more slices, you will need to modify the script.
% asl_timeseries will be of size nADC x nAcq x NEchoes


    V = spm_vol(asl_timeseries);
    M = spm_read_vols(V);

    delta_M=zeros([size(M,1),size(M,2),size(M,3)-2]);
    indices = 1:2:size(delta_M,3);
    delta_M(:,:,indices)=(M(:,:,indices+1)-M(:,:,indices)/2-M(:,:,indices+2)/2);
    indices = 2:2:size(delta_M,3);
    delta_M(:,:,indices)=(M(:,:,indices)/2+M(:,:,indices+2)/2-M(:,:,indices+1));
    delta_M(isnan(delta_M))=0;

    T1=1.5; %unit: s, t1 for tissue at 7T
    T1b=2.1; %unit: s, t1 for blood at 7T

    % compute and preprocess M0
    M0=repmat(mean(M(:,:,2:2:end)/(1-exp(-para.TR/T1)),3),[1,1,size(delta_M,3)]);
    M0(isnan(M0))=0;
    
    omega=para.post_label_delay; %unit: s
    cbf=delta_M*0.9/2/0.85./M0/T1b./(exp(-omega/T1b)-exp(-(omega+para.label_duration)/T1b)); %unit mL/g/s
    cbf(isnan(cbf))=0;
    cbf=cbf*6000;%unit mL/100g/min
  
    % save data (cbf, mean_cbf, delta_M, mean_delta_M, M0)

    [path, filename, ext] = fileparts(asl_timeseries);

    mean_cbf=mean(cbf, 3);
    mean_cbf=reshape(mean_cbf, [size(mean_cbf), 1]);
    mean_delta_M=mean(delta_M, 3);
    mean_delta_M=reshape(mean_delta_M, [size(mean_delta_M), 1]);

    cbfV = V(1); % Extract header information from the first volume
    cbfV.fname = fullfile(path, 'cbf.nii');
    cbfV.dim = [size(cbf(:,:,1)),1];  % Set the dimensions of the 2D volume (spatial dims)

    cbfV = spm_create_vol(cbfV); % Initialize the NIfTI file header using spm_create_vol

    delta_MV = V(1);
    delta_MV.fname = fullfile(path, 'delta_M.nii');
    delta_MV.dim = [size(delta_M(:,:,1)), 1];
    delta_MV = spm_create_vol(delta_MV);
	
    % Write each time point (3D volume) to the NIfTI file
    for t = 1:size(cbf, 3)
        cbfV.n = [t, 1];  % Update the header to indicate the time point
        spm_write_vol(cbfV, cbf(:, :, t));  % Write the 3D volume for time point t

	delta_MV.n = [t, 1];
	spm_write_vol(delta_MV, delta_M(:, :, t));
    end

    mean_cbfV = V(1);
    mean_cbfV.fname = fullfile(path, 'mean_cbf.nii');
    mean_cbfV.dim = [size(mean_cbf),1];
    spm_write_vol(mean_cbfV, mean_cbf);
 
    mean_delta_MV = V(1);
    mean_delta_MV.fname = fullfile(path, 'mean_delta_M.nii');
    mean_delta_MV.dim = [size(mean_delta_M),1];
    spm_write_vol(mean_delta_MV, mean_delta_M);
  
    M0V = V(1);
    M0V.fname = fullfile(path, 'M0.nii');
    M0V.dim = [size(M0(:,:,1)), 1];
    spm_write_vol(M0V, M0(:,:,1));
end

