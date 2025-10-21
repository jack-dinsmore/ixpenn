#!/bin/bash

#SBATCH -o logs/hex-%j.log
#SBATCH --time=64:00:00
#SBATCH --job-name=hex
#SBATCH --partition=kipac
#SBATCH --mem=24G
#SBATCH -c 4

source source_select.sh
source $PREFIX"src/mlnn.sh"
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh
cd IXPEML

export DET='1'
source $PREFIX"src/filenames.sh"
mkdir $NN_FOLDER
python3 -u run_build_fitsdata.py $DATA_FOLDER$FILENAME'_recon.fits' $NN_FOLDER

export DET='2'
source $PREFIX"src/filenames.sh"
mkdir $NN_FOLDER
python3 -u run_build_fitsdata.py $DATA_FOLDER$FILENAME'_recon.fits' $NN_FOLDER

export DET='3'
source $PREFIX"src/filenames.sh"
mkdir $NN_FOLDER
python3 -u run_build_fitsdata.py $DATA_FOLDER$FILENAME'_recon.fits' $NN_FOLDER
