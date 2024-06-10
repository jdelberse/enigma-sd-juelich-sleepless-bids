#!/bin/bash
# I've had the best luck with running this interactively on HTCondor with
# conda activate SHIVA_preproc

SUBS=$(awk -F" " '{print $1}' participants.tsv)
SESS="$1 $2"
echo Running SHIVA_PVS on subjects ${SUBS} sessions ${SESS}

for SUB in $SUBS; do
	for SES in $SESS; do
		if [ -d derivatives/freesurfer/${SUB}_ses-${SES} ]
		then echo Preprocessing ${SUB}
		else echo Oh! ${SUB} or ses-${SES} does not exist, skipping...
			continue
		fi
	
		echo Running ${SUB} session ${SES}
		$(pwd)/code/shiva/pvs/shiva_preproc.sh $SUB $SES #| condor_submit
	done
done

echo Done! Should be quick hopefully. Who knows. 