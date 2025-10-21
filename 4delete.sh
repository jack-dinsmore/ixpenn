#!/bin/bash
#SBATCH -o logs/delete-%j.log
#SBATCH --job-name=delete
#SBATCH --partition=kipac
#SBATCH --time=2:00:00
#SBATCH --ntasks=1
#SBATCH --mem=8G

source source_select.sh
source $PREFIX"src/mlixpe.sh"
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

export DET='1'
source src/delete-one.sh

export DET='2'
source src/delete-one.sh

export DET='3'
source src/delete-one.sh
