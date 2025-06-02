#!/bin/bash

#SBATCH -ologs/bkg-%j.log
#SBATCH --partition=kipac
#SBATCH --mem=16GB
#SBATCH --job-name=bkg
#SBATCH -t 02:00:00

source source_select.sh
source $PREFIX"src/mlbg.sh"

export DET='1'
source src/bkg-mine-one.sh


export DET='2'
source src/bkg-mine-one.sh


export DET='3'
source src/bkg-mine-one.sh
