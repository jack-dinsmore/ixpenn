#!/bin/bash

#SBATCH -ologs/unasp-%j.log
#SBATCH --partition=kipac
#SBATCH --mem=16GB
#SBATCH --job-name=unasp
#SBATCH -t 08:00:00

source source_select.sh
source $PREFIX"src/mlixpe.sh"
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

export HEADASNOQUERY=
export HEADASPROMPT=/dev/null

export DET='1'
source src/bkg-one.sh


export DET='2'
source src/bkg-one.sh


export DET='3'
source src/bkg-one.sh
