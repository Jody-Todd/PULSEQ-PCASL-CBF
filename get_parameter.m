function [para] = get_parameter(pcasl_nifti_dat, pcasl_seq_file)
% This function extracts pcasl parameters necessary to compute cbf (TR, label duration, and post label delay). See compute_cbf.m
%
% Parameters:
%	pcasl_nifti_dat: nifti file of pcasl data 
%	pcasl_seq_file: seq file of corresponding pcasl acquisition
%
% Outputs:
%	para: struct of necessary parameters for cbf computation. para will be input struct to compute_cbf.m.
%

	% read in nifti header
	asl_data = load_nii(pcasl_nifti_dat);
	nifti_hash = asl_data.hdr.hist.descrip;

	% read seq file
	seq = mr.Sequence;
	seq.read(pcasl_seq_file)
	fprintf(['loading `' pcasl_seq_file '´ ...\n']);
	seqName=seq.getDefinition('Name');
	if ~isempty(seqName), fprintf('sequence name: %s\n',seqName); end

	% confirm that seq file signature matches signature in nifti header
	if seq.signatureValue ~= nifti_hash
    		error('seq hash does not match data hash. \n seq hash: %s \n nifti hash: %s', seq_hash, nifti_hash);
	end

	% extract necessary parameters from seq file. may want to add more later
	para.TR = seq.getDefinition('TR'); % [s]
	para.label_duration = seq.getDefinition('labelDur'); % [s]
	para.post_label_delay = seq.getDefinition('PLD'); % [s]

end

