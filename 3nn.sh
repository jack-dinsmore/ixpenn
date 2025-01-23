#!/bin/bash
#
#SBATCH -o logs/nn-%j.log
#SBATCH --job-name=NN1-01002601
#SBATCH --time=48:00:00
#SBATCH --ntasks=1
##SBATCH --cpus-per-task=2
#SBATCH --mem=36G
#SBATCH --partition=owners
#SBATCH --gres gpu:4
#SBATCH -C GPU_MEM:16GB
##SBATCH -C GPU_BRD:GEFORCE
##SBATCH -C GPU_SKU:RTX_2080Ti
##SBATCH -C GPU_CC:7.5

source source_select.sh
source $PREFIX"src/mlnn.sh"
cd /home/groups/rwr/jtd/IXPEML

export DET='1'
source $PREFIX"src/filenames.sh"
echo $NN_FILE
nvidia-smi

if [ -f $NN_FILE ]; then
    echo "File "$NN_FILE" already exists."
else
    python3 run_ensemble_eval.py $SOURCE"-det"$DET --data_list $NN_FOLDER --batch_size 256
fi



export DET='2'
source $PREFIX"src/filenames.sh"
nvidia-smi
if [ -f $NN_FILE ]; then
    echo "File "$NN_FILE" already exists."
else
    python3 run_ensemble_eval.py $SOURCE"-det"$DET --data_list $NN_FOLDER --batch_size 256
fi



export DET='3'
source $PREFIX"src/filenames.sh"
nvidia-smi
if [ -f $NN_FILE ]; then
    echo "File "$NN_FILE" already exists."
else
    python3 run_ensemble_eval.py $SOURCE"-det"$DET --data_list $NN_FOLDER --batch_size 256
fi
