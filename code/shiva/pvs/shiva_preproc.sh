#!/bin/bash

# Set arguments
SUB=$1
SES=$2

code=$(pwd)/code/shiva/pvs

# Find images
img=$(pwd)/derivatives/freesurfer/${SUB}_ses-${SES}/mri/T1.mgz
mask=$(pwd)/derivatives/freesurfer/${SUB}_ses-${SES}/mri/brainmask.mgz
imgfileName=${img%".mgz"}
maskfileName=${mask%".mgz"}

# Convert to Nifti
#datalad get $(pwd)/code/pvs/convert.py
python3 $code/convert.py $img $mask

img_conv="${imgfileName}.nii.gz" 
mask_conv="${maskfileName}.nii.gz"
echo "$img >>> $img_conv"
echo "$mask >>> $mask_conv"
	
# Conform
#datalad get $(pwd)/code/pvs/conform.py
python3 $code/conform.py $img_conv $mask_conv  

img_res="${imgfileName}_resampled.nii.gz" 
mask_res="${maskfileName}_resampled.nii.gz"
echo "$img_conv >>> $img_res"
echo "$mask_conv >>> $mask_res"

# Intensity normalisation
img_norm="${imgfileName}_resampled_normalized.nii.gz" 

fcm-normalize $img_res \
	-m $mask_res \
	-o $img_norm
	
echo "$img_res >>> $img_norm" 

# Cropping
#datalad get $(pwd)/code/pvs/crop.py
python3 $code/crop.py $img_norm $mask_res

img_crop="${imgfileName}_resampled_normalized_cropped.nii.gz"
echo "$img_norm >>> $img_crop"

# Remove intermediate images
rm -f $img_res $img_norm