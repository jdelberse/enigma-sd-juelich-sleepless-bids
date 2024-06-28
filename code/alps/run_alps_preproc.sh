#!/bin/bash
# Args
SUB=$1
SES=$2

# Params
ROOT=$(pwd)
ANAT=$ROOT/$SUB/$SES/anat
DWI=$ROOT/$SUB/$SES/dwi

# Get data
datalad get $ANAT
datalad get $DWI
datalad get $ROOT/code/alps

# Create acqparams.txt
PED=$(jq '.PhaseEncodingDirection' $DWI/${SUB}_${SES}_dir-AP_dwi.json)
TET=$(jq '.TotalReadoutTime' $DWI/${SUB}_${SES}_dir-AP_dwi.json)
if [[ $PED=="j" ]] 
then
	echo 0 -1 0 $TET > $DWI/acqparams.txt
else
	echo 0 1 0 $TET >> $DWI/acqparams.txt
fi
chmod +r $DWI/acqparams.txt

#Run alps.sh
$ROOT/code/alps/alps.sh \
	-a $DWI/${SUB}_${SES}_dir-AP_dwi.nii.gz \
	-b $DWI/${SUB}_${SES}_dir-AP_dwi.bval \
	-c $DWI/${SUB}_${SES}_dir-AP_dwi.bvec \
	-m $DWI/${SUB}_${SES}_dir-AP_dwi.json \
	-v $ANAT/${SUB}_${SES}_T1w.nii.gz \
	-o $ROOT/derivatives/alps/$SUB/$SES/dwi