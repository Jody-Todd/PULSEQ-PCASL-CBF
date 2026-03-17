function  hash_match(pcasl_nifti_dat, pcasl_seq_file)
% This script ensures that the hash in the nifti data header matches the hash in the seq file. This check should be performed prior to preprocessing as preprocessing steps could modify the header.
% 
% Parameters: 
%	pcasl_nifti_dat: pcasl nifti data
%	pcasl_seq_file: pcasl seq file used to generate pcasl_nifti_dat
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
	else
		fprintf('hash of nifti data matches hash of seq file -- good \n');
	end
end

