#!/bin/bash

#SBATCH -ologs/correct-%j.log
#SBATCH --job-name=correct
#SBATCH --partition=kipac
#SBATCH --mem=16GB
#SBATCH --cpus-per-task=4
#SBATCH -t 08:00:00

source source_select.sh
source $PREFIX"src/mlixpe.sh"  > /dev/null
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh
export HEADASNOQUERY=
export HEADASPROMPT=/dev/null

export DET='1'
bash src/correct-one.sh
bash src/centroid-one.sh

export DET='2'
bash src/correct-one.sh
bash src/centroid-one.sh

export DET='3'
bash src/correct-one.sh
bash src/centroid-one.sh
