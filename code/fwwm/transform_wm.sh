sub=$1
root=$(pwd)
qsi=$root/derivatives/qsiprep

antsApplyTransforms \
    -d 3 \
    -r $qsi/$sub/ses-ebl/dwi/${sub}_ses-ebl_space-T1w_desc-preproc_dwi.nii.gz \
    -i $qsi/$sub/anat/${sub}_WM.nii.gz \
    -n GenericLabel \
    -o $qsi/$sub/anat/${sub}_space-T1w_desc-preproc_WM.nii.gz



