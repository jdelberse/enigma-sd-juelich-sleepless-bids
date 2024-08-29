#!/bin/bash
CPUS='1'
RAM='9G'
DISK='90G'

ROOT=$(pwd)
LOGS=$ROOT/derivatives/logs
WORK=/tmp

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
executable     = $ROOT/code/fwwm/run_fit_fw_model.sh
\n"

# loop over all subjects
for dir in $ROOT/sub-*; do
	sub=${dir#$ROOT/}
    for ses in ses-bl ses-sd; do
        printf "arguments = $sub $ses \n"
        printf "log       = ${LOGS}/\$(Cluster).\$(Process).${sub}.${ses}.log.txt\n"
        printf "output    = ${LOGS}/\$(Cluster).\$(Process).${sub}.${ses}.out.txt\n"
        printf "error     = ${LOGS}/\$(Cluster).\$(Process).${sub}.${ses}.err.txt\n"
        printf "Queue\n\n"
	done
done