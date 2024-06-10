#!/bin/bash
MODELS=../models
CODE=$(pwd)/code/shiva/pvs
FS=$(pwd)/derivatives/freesurfer
OUT=$(pwd)/derivatives/shiva
THRESH=0.5

SUBS=$(awk -F" " '{print $1}' participants.tsv)
SESS="$1 $2"
echo Running SHIVA_PVS on subjects ${SUBS} sessions ${SESS}

#IMAGE_DIR=./images
for SUB in $SUBS; do
	for SES in $SESS; do
		if [ -d $FS/${SUB}_ses-${SES} ]
		then echo Performing inference on ${SUB}
		else echo Oh! ${SUB} or ses-${SES} does not exist, skipping...
			continue
		fi
		mkdir -p $OUT/${SUB}/ses-${SES}

		echo Performing inference using SHIVA_PVS...
		python $CODE/predict_one_file.py \
    		--verbose --gpu 0 \
    		-m $MODELS/20211030-162753_Unet3Dv2-10.7.2-1.8-T1.VRS_fold_1x6_pi_fold_0_model.h5 \
    		-m $MODELS/20211030-162753_Unet3Dv2-10.7.2-1.8-T1.VRS_fold_1x6_pi_fold_1_model.h5 \
    		-m $MODELS/20211030-162753_Unet3Dv2-10.7.2-1.8-T1.VRS_fold_1x6_pi_fold_2_model.h5 \
    		-m $MODELS/20211030-162753_Unet3Dv2-10.7.2-1.8-T1.VRS_fold_1x6_pi_fold_3_model.h5 \
    		-m $MODELS/20211030-162753_Unet3Dv2-10.7.2-1.8-T1.VRS_fold_1x6_pi_fold_4_model.h5 \
    		-m $MODELS/20211030-162753_Unet3Dv2-10.7.2-1.8-T1.VRS_fold_1x6_pi_fold_5_model.h5 \
    		-i $FS/${SUB}_ses-${SES}/mri/T1_resampled_normalized_cropped.nii.gz \
    		-o $OUT/${SUB}/ses-${SES}/PVS_segmentation.nii.gz
    	
    	echo Thresholding PVS segmentations...
    	python $CODE/thresh_pvs.py $SUB $SES $THRESH
    	
    	echo Computing PVSVF...
    	segvol=$(fslstats $OUT/${SUB}/ses-${SES}/PVS_segmentation_05thresh.nii.gz -V)
    	PVSV=$(echo $segvol | awk -F'[^0-9]*' '$0=$2')
    	ICV=$(grep -oP '(?<=Intracranial Volume, ).*(?=, mm)' $FS/${SUB}_ses-${SES}/stats/aseg.stats)
    	
    	PVSVF="$(python3 $CODE/divide.py $PVSV $ICV 2>&1)"  # Bash can't math
    	
    	echo $SUB ses-$SES finished. 
		echo PVSV = $PVSV, ICV = $ICV, PVSVF = $PVSVF
    	
    	out=$OUT/${SUB}/pvs.stat.csv
    	
    	if [ $SES = "bl" ]; then
    		echo Subject,Session,PVSV,ICV,PVSVF >| $out; \
    		echo ${SUB},ses-${SES},$PVSV,$ICV,$PVSVF >> $out;
    	else 
    		echo ${SUB},ses-${SES},$PVSV,$ICV,$PVSVF >> $out;
    	fi
    	
    	echo Stats saved to $out
    done
done

