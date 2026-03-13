#!/usr/bin/env python

# run conda activate jt_conda_env first

import numpy as np
import nibabel as nib
from scipy.ndimage import generic_filter
import argparse
from argparse import RawTextHelpFormatter
import os
import sys
from collections import Counter




def manMeanFilter(patch):
    # Custom function to compute the mean of nonzero values.
    # Parameters:
    #   patch: patch of image to compute masked median over
    # Retruns:
    #   mean over non-zero values in patch of image
    #
    
    nonzero_values = patch[patch != 0]  # Exclude zero-valued neighbors
    nonoutlier_values = nonzero_values[nonzero_values < 6]
    return np.mean(nonoutlier_values) if nonoutlier_values.size > 0 else 0



def filterImg(img_path):
    # Filter 3D/4D nifti image using maskedMedianFilter(). If 4D, apply filter to each 3D volume separately.
    # Parameters:
    #   img_path: path to 3D/4D nifti image data (X,Y,Z,T)
    # Returns:
    
    
    img = nib.load(img_path)
    img_data = img.get_fdata()
    img_data = np.nan_to_num(img_data)
    
    #filtered_data = np.zeros_like(img_data)

    filtered_data = generic_filter(
        img_data, 
        function=manMeanFilter, 
        size=(3, 3, 3), 
        mode="constant", 
        cval=0  # Zero-padding at edges
    )
        
    # Save the filtered image
    basename = os.path.basename(img_path)
    filename = basename.split('.nii')[0]
    parent_dir = os.path.dirname(img_path)


    filtered_nii = nib.Nifti1Image(filtered_data, img.affine, img.header)
    nib.save(filtered_nii, os.path.join(parent_dir, filename + '_manmean3v_nonout.nii'))




parser = argparse.ArgumentParser(description="Perform masked median filter on data from top_directory/subj_dir/path_to_data.", formatter_class=RawTextHelpFormatter)
parser.add_argument('--top_directory', type=str, required=True, help='top directory where subjects data is found')
parser.add_argument('--path_to_data', type=str, required=True, help='path relative to top_directory/subject_directory to nifti image file to be used in computation of ICC map')

args = parser.parse_args()

if __name__ == "__main__":
    subj_dirs = [d for d in os.listdir(args.top_directory) if d.startswith('CVRTRT8P')]
    subj_dirs = sorted(subj_dirs, key=lambda x: (x[0:11], x[-8:])) # sort first by subject ID then by date -> [Subj1 run1, Subj1 run2, Subj2 run1, Subj2 run2 ...]

    # ensure each subject has two runs
    subj_ids = [item[:11] for item in subj_dirs]
    counts = Counter(subj_ids)
    if not all(count == 2 for count in counts.values()):
        print("At least one subject has missing data. Check subject directories before proceeding.")
        sys.exit(1)
        
    # loop through top_dir and pass img_path to filterImg
    for subj_dir in subj_dirs:
        img_path = os.path.join(args.top_directory, subj_dir, args.path_to_data)
        print(img_path)
        if os.path.exists(img_path):
            filterImg(img_path)
           
        else:
            print(f"image data missing for subject {subj_dir}")
            sys.exit(1)

    
