# Data processing pipeline to quantify cerebral blood flow (CBF) from arterial spin labeling (ASL) MRI data.

![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![MATLAB](https://img.shields.io/badge/MATLAB-ED8B00?style=flat&logo=mathworks&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)

## Overview
This pipeline takes raw ASL data as input and processes the data to compute CBF at a voxel level according to the methods specified in the [ASL White Paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC4190138/).

## Important Scripts
* process_asl.sh: master script that processes the ASL data to compute CBF maps. It takes the raw data, anatomical data, and output directory name as inputs.
* compute_cbf.m: called by asl_tools.m to compute CBF in units of ml/100g/min.

## Workflow
1. Convert dicoms to nifti format
2. Preprocess anatomical (T1) images (skull strip, intensity normalization, segmentation)
3. Perform motion correction using SPM
4. Compute CBF according to the the equation from the ASL White Paper
5. Coregister ASL and anatomical images
6. Masking
7. Run a quality control on outputs

## Helper Scripts
Some scripts in this repo are not part of the data processing pipeline but assist in statistical analyses and reliability studies.
* icc_roi.py: calculates the intraclass correlation coefficient (ICC) from a region of interest (ROI) given repeated measures data. This script is important for ensuring that the data acquisition and processing pipelines are robust.
* icc_map.py: calculates the ICC in each voxel as opposed to within an ROI. This requires the normalization of CBF maps to a standard space (MNI space).
