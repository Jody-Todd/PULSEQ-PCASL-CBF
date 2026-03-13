#!/bin/bash

# this script plots QC images of CBF from a text file of subjects with cbf.nii images
# Parameters:	
#	$1:	text file of paths to CBF data
#
# Ouputs saved in same location as CBF data
#

topDir=$1
for caseDir in $(ls $topDir); do
	if [[ $caseDir == CVRTRT8P* ]]; then
		/usr/local/MATLAB/R2023a/bin/matlab -nodisplay -nosplash -r "plotQCResults('$topDir/$caseDir/output/mean_baselineCBF.nii'); exit;"


	#if [ ! -e $topDir/$caseDir/output/wm_baselineCBF.nii ]; then 
		# calculate baseline measurements
		#matlab -nodisplay -nosplash -r "calc_baseline('$topDir/$caseDir'); exit"
		#rp_file=$(ls $topDir/$caseDir/temp/rp_*.txt)
		#echo $rp_file
		#matlab -nodisplay -nosplash -r "plot_motion('$rp_file'); exit;"

		# mask baseline data
		#fslmaths $topDir/$caseDir/output/baselineCBF.nii -mas $topDir/$caseDir/temp/gm_func.nii.gz $topDir/$caseDir/output/gm_baselineCBF.nii.gz; gunzip $output_dir/output/gm_baselineCBF.nii.gz
		#fslmaths $topDir/$caseDir/output/baselineCBF.nii -mas $topDir/$caseDir/temp/wm_func.nii.gz $topDir/$caseDir/output/wm_baselineCBF.nii.gz; gunzip $topDir/$caseDir/output/wm_baselineCBF.nii.gz;
	#fi



	#rp_file=$(ls $caseDir/temp/rp_*.txt)
	#matlab -nodisplay -nosplash -r "plot_motion('$rp_file', false); exit;"
	
	#matlab -nodisplay -nosplash -r "calc_baseline('$caseDir'); exit"
	#fslmaths $caseDir/output/gmwm_mean_baselineCBF_MNI.nii -s 4 $caseDir/output/gmwm_mean_baselineCBF_MNI_smooth4.nii
	#fslmaths $caseDir/output/gmwm_mean_baselineCBF_MNI_smooth4.nii.gz -mas /usr/local/fsl/data/standard/MNI152_T1_2mm_brain_mask.nii.gz $caseDir/output/gmwm_mean_baselineCBF_MNI_smooth4_masked.nii.gz
	
	#fslmaths $caseDir/output/gmwm_baselineCBF.nii -s 3 $caseDir/output/gmwm_baselineCBF_smooth3.nii
	#fslmaths $caseDir/output/gmwm_baselineCBF_smooth3.nii.gz -mas $caseDir/temp/brain_mask_func.nii.gz $caseDir/output/gmwm_baselineCBF_smooth3_masked.nii.gz

        #fslmaths $caseDir/output/gmwm_baselineCBF_smooth3_masked.nii.gz -Tmean "$caseDir/output/gmwm_baselineCBF_smooth3_masked_mean.nii"
        #fslmaths $caseDir/output/gmwm_baselineCBF_smooth3_masked.nii.gz -Tstd "$caseDir/output/gmwm_baselineCBF_smooth3_masked_std.nii"
	fi
done

	

