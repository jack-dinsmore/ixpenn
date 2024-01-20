#!/bin/bash

#SBATCH -ologs/init-%j.log
#SBATCH --partition=kipac
#SBATCH --mem=16GB
#SBATCH --job-name=init
#SBATCH -t 08:00:00

source source_select.sh
source $PREFIX"init/mlixpe.sh"
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

export HEADASNOQUERY=
export HEADASPROMPT=/dev/null

export DET='1'
bash src/init-one.sh


export DET='2'
bash src/init-one.sh


export DET='3'
bash src/init-one.sh
