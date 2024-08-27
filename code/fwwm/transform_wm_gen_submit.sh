#!/bin/bash
CPUS='1'
RAM='9G'
DISK='90G'

ROOT=$(pwd)
CODE=$ROOT/code/fwwm/transform_wm.sh
LOGS=$ROOT/derivatives/logs
#ANTS=$ROOT/../containers/images/neurodesk/neurodesk-ants--2.5.1.simg
ANTS=$ROOT/../containers/images/bids/bids-fmriprep--24.0.0.sing
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
for dir in $ROOT/sub-*; do
        sub=${dir#$ROOT/}
        printf "arguments = exec \ 
                -B ${SYMLINK},${WORK},${ROOT} \
                $ANTS \
                $CODE $sub \n"
        printf "log       = ${LOGS}/\$(Cluster).\$(Process).${sub}.log.txt\n"
        printf "output    = ${LOGS}/\$(Cluster).\$(Process).${sub}.out.txt\n"
        printf "error     = ${LOGS}/\$(Cluster).\$(Process).${sub}.err.txt\n"
        printf "Queue\n\n"
done