#!/bin/bash

# This script computes CBF from a single echo Pulseq-PCASL acquisition. 
#
# Steps:
#
# Parameters:
#	$1: path to ASL recon directory 
#

export s=5 # set FWHM parameter for ASL data [mm]

set -e 

export user=`whoami`
export OMP_NUM_THREADS=2
export MKL_NUM_THREADS=2

asl_dir=${1%/}
seq_file=("$asl_dir"/*pcasl*.seq)

if [[ ${#seq_file[@]} -gt 1 ]]; then
    echo "Error: Multiple *pcasl*.seq files found in $asl_dir. Expected exactly one."
    # Exit the script with an error code
    exit 1
fi


script_dir=$(dirname "$0")
if [[ $script_dir != /* ]]; then
   script_dir=`pwd`/$script_dir
fi

cd $script_dir

echo "++Remove motion contribution to ASL timeseries, smooth ASL data, Compute CBF+++++++++++++++++++"
matlab -nodisplay -r "environment_config(); hash_match('$asl_dir/test3.nii','$seq_file'); asl_tools('$asl_dir/test3.nii', $s); para = get_parameter('$seq_file'); compute_cbf(para, '$asl_dir/srtest3.nii'); exit;"

# get QC images for CBF
matlab -nodisplay -nosplash -r "plotQCResults('$asl_dir/mean_cbf.nii'); exit;"

rp_file=$(ls $asl_dir/rp_*.txt)
echo "motion file $rp_file found"
matlab -nodisplay -nosplash -r "plot_motion('$rp_file'); exit;"

