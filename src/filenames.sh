export DATA_FOLDER=$PREFIX"data/"
export RAW_FILENAME="event_l1/ixpe"$OBS"_det"$DET"_evt1_v"$VERSION
export FILENAME="recon/ixpe"$OBS"_det"$DET"_evt1_v"$VERSION # recon
export NN_FOLDER=$DATA_FOLDER'recon/'$SOURCE'-det'$DET/
export NN_FILE='/home/groups/rwr/jtd/IXPEML/_recon_'$SOURCE'-det'$DET'___'$SOURCE'-det'$DET'__ensemble.fits'

export FINAL_FOLDER=$DATA_FOLDER"event_nn"
export FINAL_FILENAME="ixpe"$OBS"_det"$DET"_nn"

date
echo $SOURCE $OBS $DET
