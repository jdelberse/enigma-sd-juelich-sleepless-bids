### Author: JD Elberse
### Date: 26/03/24
### This code relabels the SleepLess dataset sessions

import os
import pandas as pd
import argparse as ap

# Specify if this is a test or if data should actually be renamed
parser = ap.ArgumentParser(prog='RenameSessionLabels',
    description='Labels sessions according to how the participant slept')
parser.add_argument('-t', '--test', action='store_true')
args = parser.parse_args()

# Load, add sub-labels, set sub as index
tsv = pd.read_csv("participants.tsv", sep="\t")
tsv.set_index('participant_id', inplace=True)

# Loop over subjects
for sub in tsv.index:
    
    # Set labels to modify
    ses_labs = {"ses-1" : "ses-bl", "ses-2" : "ses-sd"}

    # Loop over sessions
    for ses in ses_labs.keys():

        # Loop over MRI directories
        for dirs in ['anat', 'dwi']:
            root = f"{sub}/{ses}/{dirs}"
            if not os.path.exists(root):
                continue
            
            # Loop over files in the directories
            for files in os.listdir(root):
                old_scan = os.path.join(root,files)
                new_scan = os.path.join(root,files.replace(ses, ses_labs[ses]))

                # If the old path exists and the new path does not
                if os.path.exists(old_scan) and not os.path.exists(new_scan):
                    
                    # Print how the file will be renamed
                    print(f"{old_scan} >>> {new_scan}")
                    
                    # If this is not a test run, then rename it
                    if not args.test:
                        os.rename(old_scan, new_scan)
                else:
                    print(f"{new_scan} exists. Skipping...")
        
        old_dir = f"{sub}/{ses}"
        new_dir = f"{sub}/{ses_labs[ses]}"

        # If the old path exists and the new path does not  
        if os.path.exists(old_dir) and not os.path.exists(new_dir):
                
            # Print how the directory will be renamed
            print(f"{old_dir} >>> {new_dir}")
                
            # If this is not a test run, then rename it
            if not args.test:
                os.rename(old_dir, new_dir)
            else:
                print(f"{new_dir} exists. Skipping...")
