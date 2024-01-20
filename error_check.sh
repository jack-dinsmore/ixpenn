#!/bin/bash


for LOG_FILE in "$@"
do
    echo $LOG_FILE
    grep --color -n 'Segmentation' $LOG_FILE
    grep --color -n 'Traceback' $LOG_FILE
    grep --color -n 'ERROR' $LOG_FILE
    echo
done
