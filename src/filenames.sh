export DATA_FOLDER=$PREFIX"data/"$SETNUM"/"
if [ -z ${VERSION+x} ]; then
    # Version variable is unset
    case $DET in
        1)
            FILE_VERSION=$VERSION1
            ;;
        2)
            FILE_VERSION=$VERSION2
            ;;
        3)
            FILE_VERSION=$VERSION3
            ;;
   esac
else
    FILE_VERSION=$VERSION
    # Version variable is set
fi
export RAW_FILENAME="event_l1/ixpe"$OBS"_det"$DET"_evt1_v"$FILE_VERSION
echo Using file $RAW_FILENAME
export FILENAME="recon/ixpe"$OBS"_det"$DET"_evt1_v"$FILE_VERSION # recon
export NN_FOLDER=$DATA_FOLDER'recon/'$SOURCE'-det'$DET/
export NN_FILE='/home/groups/rwr/jtd/IXPEML/_recon_'$SOURCE'-det'$DET'___'$SOURCE'-det'$DET'__ensemble.fits'

if [ -z "${USE_MOM}" ]; then
    export FINAL_FOLDER=$DATA_FOLDER"event_mom"
    export FINAL_FILENAME="ixpe"$OBS"_det"$DET"_l2"
    echo "Using Moments"
else
    export FINAL_FOLDER=$DATA_FOLDER"event_nn"
    export FINAL_FILENAME="ixpe"$OBS"_det"$DET"_nn"
    echo "Using NN"
fi

date
echo $SOURCE $OBS $DET
