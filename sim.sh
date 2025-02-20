#!/bin/bash

#SBATCH --mem=16G
#SBATCH --partition=kipac
#SBATCH --time=16:00:00
#SBATCH -c 4
#SBATCH -n 1
#SBATCH -o logs/sim-%j.log
#SBATCH --job-name=sim


source ~/mlixpe.sh
source ~/gpdsw/setup.sh

OUTPUT=./data/sim/event_l1/ixpe_pd1_spec2_ang0_det1_evt1_v01.fits

#~/gpdsw/bin/ixpesim -n 2000000 \
#            --random-seed 194 \
#            --output-file $OUTPUT \
#            --log-file data/sim/sim.log
#            --src-spectrum powerlaw \
#            --src-index -2 \
#            --src-pol-degree 1 \
#            --src-pol-angle 0 \
#            --dme-pressure 687 \

#echo "Fits splitting"
#python3 ~/gpdsw/gpdswpy/fitsplit.py $OUTPUT 

~/gpdsw/bin/ixperecon \
            --write-tracks \
            --input-files $OUTPUT \
            --threshold 20 \
            --output-folder data/sim/recon
            
