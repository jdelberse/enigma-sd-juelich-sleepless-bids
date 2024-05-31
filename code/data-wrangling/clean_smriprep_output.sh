#!/bin/bash
# Author: JD Elberse
# This code cleans the smriprep folder in derivatives to reduce the amount of
# redundant folders (multile sub-*, ses-* folders) and separate freesurfer output
# from smriprep output.

root=./derivatives # set root directory
old=$root/smriprep_old  # set name for directory to take data out of
new=$root/smriprep # set name for new directory to be created
tmp=$root/tmp

fsnew=$root/freesurfer

mv $new $old # rename current smriprep directory to smriprep_old

mkdir $new # make new directory
mkdir $fsnew # make freesurfer directory
mkdir $tmp # make a temporary directory

for dir in $old/sub-*; do # loop over subject directories
    sub=${dir#$old/} # get subname by removing the root
    mkdir $new/$sub

    echo Processing $sub
    for ses in ses-bl ses-sd; do # loop over sessions
        echo $ses

        # SMRIPrep wrangling
        data=$old/$sub/$ses/smriprep # specify data folder
        cp -r $data/. $tmp/ # copy all files into the new folder

        for thing in $tmp/*; do # for all files and folders in this data folder
            name=${thing#$tmp/} # get filename
            if [[ $name == $sub ]]; then continue; fi # except for the sub folder
            mv $thing $tmp/$sub/$ses/$name # move into the session folder
        done
        mv $tmp/$sub/figures $tmp/$sub/$ses/figures # also move the figures folder
        mv $tmp/$sub/$ses $new/$sub/$ses

        rm -rf $tmp/* # clear tmp folder
        
        echo Copied data in $data to $new

        # Freesurfer wrangling
        fs=$old/$sub/$ses/freesurfer #specify freesurfer folder
        cp -r $fs/fsaverage $fsnew/fsaverage # copy fsaverage (overwrite doesn't matter)
        cp -r $fs/$sub $fsnew/${sub}_${ses} # copy sub folder, add ses label
        echo Copied data in $fs to $fsnew

    done
done

rm -rf $tmp
# Remove the old folder. Best to do this manually.
# rm -rf $old 







