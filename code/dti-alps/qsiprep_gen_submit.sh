#!/bin/bash

CPUS='4'
RAM='32G'
DISK='90G'

ROOT=$(pwd)
LOGS=$ROOT/derivatives/logs
CONTAINERS=/data/project/sleep_ENIGMA_deprivation/enigma-sd-glymphatic/containers/
QSRIPREP=$CONTAINERS/images/bids/bids-qsiprep--0.20.0.sing
WORK='/tmp'
OUT=$ROOT/derivatives
SYMLINK=$ROOT/.git/annex/objects

# create the logs or out dir if it doesn't exist
[ ! -d "${LOGS}" ] && mkdir -p "${LOGS}"
[ ! -d "${OUT}" ] && mkdir -p "${OUT}"

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
    for ses in ses-bl ses-sd; do
    	sub=${dir#$ROOT/}
        printf "arguments = run \
        --cleanenv \
        -B ${SYMLINK},${WORK},${ROOT},${OUT},/opt/freesurfer/7.4/license.txt:/opt/freesurfer/license.txt \
        ${QSRIPREP} \
        --skull-strip-fixed-seed \
        --work-dir ${WORK} \
        ${ROOT} ${OUT} participant \
        --participant-label ${sub} \
        --output-resolution 1 \
        --skip-bids-validation\n"
        printf "log       = ${LOGS}/\$(Cluster).\$(Process).${sub}.${ses}.log.txt\n"
        printf "output    = ${LOGS}/\$(Cluster).\$(Process).${sub}.${ses}.out.txt\n"
        printf "error     = ${LOGS}/\$(Cluster).\$(Process).${sub}.${ses}.err.txt\n"
        printf "Queue\n\n"
    done
done
