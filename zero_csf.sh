#!/bin/bash

# This script sums the GM and WM masks to create a new mask where CSF is zeroed

topDir=$1
for caseDir in $(ls $topDir); do
	if [ ! -e $topDir/$caseDir/temp/gm_func.nii ]; then
		gunzip $topDir/$caseDir/temp/gm_func.nii.gz; gunzip $topDir/$caseDir/temp/wm_func.nii.gz
       	fi
	fslmaths $topDir/$caseDir/temp/gm_func.nii -add $topDir/$caseDir/temp/wm_func.nii $topDir/$caseDir/temp/gmwm_func.nii; gunzip $topDir/$caseDir/temp/gmwm_func.nii.gz
	fslmaths $topDir/$caseDir/output/mean_baselineCBF.nii -mas $topDir/$caseDir/temp/gmwm_func.nii $topDir/$caseDir/output/gmwm_mean_baselineCBF.nii; gunzip $topDir/$caseDir/output/gmwm_mean_baselineCBF.nii.gz
done

