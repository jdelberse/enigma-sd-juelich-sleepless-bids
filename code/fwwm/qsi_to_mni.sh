#!/bin/bash
sub=$1
ses=$2
root=$(pwd)
smri=$root/derivatives/smriprep
qsi=$root/derivatives/qsiprep

antsApplyTransforms \
    -d 4 \
    -r $smri/$sub/$ses/anat/${sub}_${ses}_desc-preproc_T1w.nii.gz \
    -i $qsi/$sub/$ses/dwi/${sub}_${ses}_dir-AP_space-T1w_desc-preproc_dwi.nii.gz \
    -n GenericLabel \
    -o $qsi/$sub/$ses/dwi/${sub}_${ses}_dir-AP_space-MNI152NLin2009cAsym_desc-preproc_dwi.nii.gz \
    --verbose