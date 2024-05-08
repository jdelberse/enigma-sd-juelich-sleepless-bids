### Author: JD Elberse
### Date: 28/03/24
### This code extracts DTI-ALPS data from the derivatives folder

import os
import pandas as pd

# Load, add sub-labels, set sub as index
tsv = pd.read_csv("participants.tsv", sep="\t")
tsv.set_index('participant_id', inplace=True)

# Create new output csv
out = tsv
out['dti-alps-baseline'] = 0
out['dti-alps-sleep-deprivation'] = 0

# Loop over subjects, collect DTI-ALPS data
for sub in tsv.index:
	bl_path = f"derivatives/{sub}/ses-ebl/dwi/alps.stat/alps.csv"
	if os.path.exists(bl_path):
		alps_bl = pd.read_csv(bl_path)['alps'].item()
	else:
		alps_bl = "n/a"

	sd_path = f"derivatives/{sub}/ses-sd/dwi/alps.stat/alps.csv"
	if os.path.exists(sd_path):
		alps_sd = pd.read_csv(sd_path)['alps'].item()
	else:
		alps_sd = "n/a"

	out.loc[sub,'dti-alps-baseline'] = alps_bl
	out.loc[sub,'dti-alps-sleep-deprivation'] = alps_sd

# Save output csv to derivatives
out.to_csv("derivatives/participants_with_alps.csv")
