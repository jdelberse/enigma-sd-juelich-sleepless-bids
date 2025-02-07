#!/bin/bash
CPUS='1'
RAM='9G'
DISK='90G'

ROOT=$(pwd)
CODE=$ROOT/code/fwwm/qsi_to_mni.sh
LOGS=$ROOT/derivatives/logs
#ANTS=$ROOT/../containers/images/neurodesk/neurodesk-ants--2.5.1.simg
ANTS=$ROOT/../code/containers/images/bids/bids-fmriprep--24.1.1.sing
WORK=/tmp
SYMLINK=$ROOT/.git/annex/objects

# create the logs dir if it doesn't exist
[ ! -d "${LOGS}" ] && mkdir -p "${LOGS}"

# print the .submit header
printf "# The environment
universe       = vanilla
getenv         = True
request_cpus   = ${CPUS}
request_memory = ${RAM}
request_disk   = ${DISK}

# Execution
executable     = /usr/bin/singularity
\n"

# loop over all subjects
for dir in $ROOT/sub-018; do
        for ses in ses-bl ses-sd; do
                sub=${dir#$ROOT/}
                printf "arguments = exec \ 
                        -B ${SYMLINK},${WORK},${ROOT} \
                        $ANTS \
                        $CODE $sub $ses \n"
                printf "log       = ${LOGS}/\$(Cluster).\$(Process).${sub}.${ses}.log.txt\n"
                printf "output    = ${LOGS}/\$(Cluster).\$(Process).${sub}.${ses}.out.txt\n"
                printf "error     = ${LOGS}/\$(Cluster).\$(Process).${sub}.${ses}.err.txt\n"
                printf "Queue\n\n"
        done
done