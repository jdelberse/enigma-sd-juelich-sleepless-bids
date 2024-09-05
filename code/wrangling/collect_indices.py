### Author: JD Elberse
### Date: 11/06/24
### This code extracts glymphatic indices from the derivatives folder and adds them
### to a new participants.tsv

import os
import pandas as pd
root = os.getcwd()

# Load, add sub-labels, set sub as index
tsv = pd.read_csv("participants.tsv", sep="\t")
tsv.set_index('participant_id', inplace=True)

# Set parameters
pvs_source = "shiva"
sessions = ["ses-bl","ses-sd"]

# Create new output csv
out = tsv
## PVS Volume Fraction
out['pvsvf-baseline'] = 0
out['pvsvf-sleep-deprivation'] = 0

## Choroid Plexus Volume Fraction
out['cpvf-baseline'] = 0
out['cpvf-sleep-deprivation'] = 0

# Mean and Relative Free Water Volume
out['mfwi-baseline'] = 0
out['mfwi-sleep-deprivation'] = 0

out['rfwi-baseline'] = 0
out['rfwi-sleep-deprivation'] = 0

## DTI-ALPS
out['dti-alps-baseline'] = 0
out['dti-alps-sleep-deprivation'] = 0

# Loop over subjects, collect DTI-ALPS data
for sub in tsv.index:
	print(f"Processing {sub}")
	pvsvf = {}
	cpvf = {}
	mfwi = {}
	rfwi = {}
	alps = {}
	for ses in sessions:
	
		## PVSVF
		pvs_path = f"derivatives/{pvs_source}/{sub}/pvs.stat.csv"
		if os.path.exists(pvs_path):
			pvs = pd.read_csv(pvs_path).set_index("Session")
			pvsvf[ses] = pvs.loc[ses]['PVSVF']
			print(f"PVS data for {ses} found at {pvs_path}")
		else:
			pvsvf[ses] = "n/a"
			print("No PVS data found")

		## CPVF
		stats_path = f"derivatives/freesurfer/{sub}_{ses}/stats/aseg.stats"
		if os.path.exists(stats_path):
			stats = pd.read_csv(f"{stats_path}.csv") #Open aseg.stats
			cp_left = stats.loc[stats["StructName"] == "Left-choroid-plexus"]["Volume_mm3"].item() # Left CP volume
			cp_right = stats.loc[stats["StructName"] == "Right-choroid-plexus"]["Volume_mm3"].item() # Right CP volume
			
			cp = (cp_right + cp_left) / 2 # Take the average of left and right
			icv = pvs.loc[ses]['ICV'] # Get the ICV from the PVS data file
			cpvf[ses] = cp/icv # Calculate the CPVF
			print(f"CPlex data for {ses} found at {stats_path}.csv")
		else:
			cpvf[ses] = "n/a"
			print("No CPlex data found")
		
		## MFWI and RFWI
		fwi_path = f"derivatives/qsiprep/{sub}/fw.stat.csv"
		if os.path.exists(fwi_path):
			fwi = pd.read_csv(fwi_path).set_index("ses")
			mfwi[ses] = fwi.loc[ses, "mfwi"]
			rfwi[ses] = fwi.loc[ses, "rfwi"]
			print(f"Mean and Relative Free water Index for {ses} found at {fwi_path}")
		else:
			mfwi[ses] = "n/a"
			rfwi[ses] = "n/a"
			print("No Free Water data found")

		## ALPS
		alps_path = f"derivatives/alps/{sub}/{ses}/alps.stat/alps.csv"
		if os.path.exists(alps_path):
			alps[ses] = pd.read_csv(alps_path)['alps'].item()
			print(f"ALPS data for {ses} data found at {alps_path}")
		else:
			alps[ses] = "n/a"
			print("No ALPS data found")
		
		if ses == sessions[0]:
			out.loc[sub, 'pvsvf-baseline'] = pvsvf[ses]
			out.loc[sub, 'cpvf-baseline'] = cpvf[ses]
			out.loc[sub, 'mfwi-baseline'] = mfwi[ses]
			out.loc[sub, 'rfwi-baseline'] = rfwi[ses]
			out.loc[sub, 'dti-alps-baseline'] = alps[ses]
		else:
			out.loc[sub, 'pvsvf-sleep-deprivation'] = pvsvf[ses]
			out.loc[sub, 'cpvf-sleep-deprivation'] = cpvf[ses]
			out.loc[sub, 'mfwi-sleep-deprivation'] = mfwi[ses]
			out.loc[sub, 'rfwi-sleep-deprivation'] = rfwi[ses]
			out.loc[sub, 'dti-alps-sleep-deprivation'] = alps[ses]
	print(f"Finished!\n")

out_path = "derivatives/participants_with_indices.tsv"
out.to_csv(f"{root}/{out_path}", sep='\t')
print(f"Saved to {out_path}.")