#!/bin/bash

for LOG_FILE in $1 
do
    echo $LOG_FILE
    grep --color -n 'Segmentation' $1
    grep --color -n 'Traceback' $1
    grep --color -n 'ERROR' $1
    grep --color -n 'Error' $1
    echo
done
