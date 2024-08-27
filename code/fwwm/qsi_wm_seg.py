### Author: JD Elberse
### Date: 09/07/24
### This code makes a WM segmentation from QSI outputs

# Packages
import os
import numpy as np
import pandas as pd
import nibabel as nib

# Load Aseg
root = os.getcwd()
qsi = f"{root}/derivatives/qsiprep"

# Set parameters
# Load, add sub-labels, set sub as index
tsv = pd.read_csv("participants.tsv", sep="\t")
tsv.set_index('participant_id', inplace=True)

for sub in tsv.index:
    # Load aseg data
    aseg = nib.load(f"{qsi}/{sub}/anat/{sub}_desc-aseg_dseg.nii.gz")
    aseg_data = aseg.get_fdata()

    # Get WM segmentation
    wm_labels = [2, 41]
    wm_data = np.isin(aseg_data, wm_labels).astype(np.uint8)

    # Create WM image
    wm = nib.Nifti1Image(wm_data, aseg.affine)
    nib.save(wm, f"{qsi}/{sub}/anat/{sub}_WM.nii.gz")


