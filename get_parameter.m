function [para] = get_parameter(pcasl_seq_file)
% This function extracts pcasl parameters necessary to compute cbf (TR, label duration, and post label delay). See compute_cbf.m
%
% Parameters:
%	pcasl_seq_file: seq file of corresponding pcasl acquisition
%
% Outputs:
%	para: struct of necessary parameters for cbf computation. para will be input struct to compute_cbf.m.
%

	% read seq file
	seq = mr.Sequence;
	seq.read(pcasl_seq_file)

	% extract necessary parameters from seq file. may want to add more later
	para.TR = seq.getDefinition('TR'); % [s]
	para.label_duration = seq.getDefinition('labelDur'); % [s]
	para.post_label_delay = seq.getDefinition('PLD'); % [s]

end

