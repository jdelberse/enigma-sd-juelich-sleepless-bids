### Author: JD Elberse
### Date: 26/08/24
### This code calculates the mean FW index and the relative FW index in the white matter (WM)

# Packages
import os
import numpy as np
import pandas as pd
import nibabel as nib

# Params & Paths
root = os.getcwd()
qsi = f"{root}/derivatives/qsiprep"

subs = pd.read_csv(f"{root}/participants.tsv", sep="\t")["participant_id"]
subs = subs.iloc[1:] # Drop the sub-008 due to lack of data
sessions = ["ses-bl", "ses-sd"]

for sub in subs:
    print(f"Subject: {sub}")
    init = {"sub" : [sub] * 2, "ses" : sessions, "mfwi" : [0,0], "rfwi" : [0,0]} # Initialise data
    data = pd.DataFrame(init) # Initialise dataframe

    for ses in sessions:
        print(f"Session: {ses}")

        # Load FW scalar
        fw = nib.load(f"{qsi}/{sub}/{ses}/dwi/{sub}_{ses}_dir-AP_space-T1w_FW.nii.gz")
        fw_data = fw.get_fdata()
        
        # Load WM mask
        wm = nib.load(f"{qsi}/{sub}/anat/{sub}_space-T1w_desc-preproc_WM.nii.gz")
        wm_data = wm.get_fdata()

        # Calculate voxel volume
        voxdims = np.abs(fw.affine.diagonal())[:3]
        voxvol = np.prod(voxdims)

        # Compute mean FW index
        fwwm = fw_data * wm_data
        mean_fw_index = np.mean(fwwm)
        print(f"Mean Free Water Index: {mean_fw_index}")

        # Compute relative FW index
        rel_fwwm = fwwm > 0.1
        rel_fw_index = (np.count_nonzero(rel_fwwm) * voxvol) / (np.count_nonzero(wm_data) * voxvol)
        print(f"Relative Free Water Index: {rel_fw_index}")

        # Store data in dataframe
        data.loc[data.ses == ses, "mfwi"] = mean_fw_index
        data.loc[data.ses == ses, "rfwi"] = rel_fw_index
    
    out_path = f"{qsi}/{sub}/fw.stat.csv"
    data.to_csv(out_path)
    print(f"Saved to {out_path}")

