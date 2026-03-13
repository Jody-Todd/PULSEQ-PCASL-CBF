#!/bin/bash

# This script computes CBF from a single echo ASL acquisition. 
#
# Steps
#	1. T1 preprocessing (skull strip, intensity normalization, segmentation)
#	2. motion correction of ASL timeseries using asl_tools.m
#	3. filter motion estimates from ASL timeseries using asl_tools
#	4. cbf computation using equation in Alsop et al., 2021
#	5. perform anatomical functional coregistration
#	6. align masks from T1 to functional image space
#	7. mask outputs
#	8. calculate baseline measurements
#	9. plot motion parameters
#
# Parameters:
#	$1: path to ASL dicom (e.g. path to subject's CVR_lowres_mb2_nograppa_2echo_Mosaic) 
#	$2: path to store outputs
#

export s=5 # set FWHM parameter for ASL data [mm]

set -e 

export user=`whoami`
export OMP_NUM_THREADS=2
export MKL_NUM_THREADS=2
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/$user/ebip_share/jtodd/pulse_seq_dev/PULSEQ-PCASL-CBF/libs

asl_dir=$1
output_dir=$2

script_dir=$(dirname "$0")
if [[ $script_dir != /* ]]; then
   script_dir=`pwd`/$script_dir
fi

if [ ! -e $output_dir/temp ]; then
	mkdir -p $output_dir/temp
	mkdir -p $output_dir/output 
fi

cd $script_dir

echo "++Remove motion contribution to ASL timeseries, smooth ASL data, Compute CBF+++++++++++++++++++"
/usr/local/MATLAB/R2023a/bin/matlab -nodisplay -r "addpath('/home/$user/ebip_share/jtodd/matlab/spm8/'); addpath('/home/$user/ebip_share/jtodd/matlab/asl_toolbox/'); asl_tools('$output_dir/temp/echo1.nii', $s); environment_config(); para = get_parameter('$output_dir/temp', 0); compute_cbf(para, '$output_dir/temp/srecho1.nii'); exit;"

# cp output files to $output_dir/output
cp $output_dir/temp/mean_cbf_masked.nii $output_dir/output/mean_cbf_masked.nii 

# get QC images for CBF
/usr/local/MATLAB/R2023a/bin/matlab -nodisplay -nosplash -r "plotQCResults('$output_dir/output/mean_cbf_masked.nii'); exit;"

rp_file=$(ls $output_dir/temp/rp_*.txt)
echo $rp_file
/usr/local/MATLAB/R2023a/bin/matlab -nodisplay -nosplash -r "plot_motion('$rp_file'); exit;"



