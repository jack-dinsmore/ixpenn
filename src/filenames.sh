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

# Set the other variables
case $DET in
    1)
        if [ -z "${PAYNUM1}" ]; then
            PAYNUM=$PAYNUM
        else
            PAYNUM=$PAYNUM1
        fi
        if [ -z "${ATTNUM1}" ]; then
            ATTNUM=$ATTNUM
        else
            ATTNUM=$ATTNUM1
        fi
        ;;
    2)
        if [ -z "${PAYNUM1}" ]; then
            PAYNUM=$PAYNUM
        else
            PAYNUM=$PAYNUM2
        fi
        if [ -z "${ATTNUM1}" ]; then
            ATTNUM=$ATTNUM
        else
            ATTNUM=$ATTNUM2
        fi
        ;;
    3)
        if [ -z "${PAYNUM1}" ]; then
            PAYNUM=$PAYNUM
        else
            PAYNUM=$PAYNUM3
        fi
        if [ -z "${ATTNUM1}" ]; then
            ATTNUM=$ATTNUM
        else
            ATTNUM=$ATTNUM3
        fi
        ;;
    *)
        echo "Could not recognize detector"
        ;;
esac


export RAW_FILENAME="event_l1/ixpe"$CHUNK"_det"$DET"_evt1_v"$FILE_VERSION
echo Using file $RAW_FILENAME
export FILENAME="recon/ixpe"$CHUNK"_det"$DET"_evt1_v"$FILE_VERSION # recon
export NN_PREPATH=$(python3 src/get_nn_path.py)
export NN_FOLDER=$DATA_FOLDER'recon/'$SOURCE'-det'$DET/
export NN_FILE='/home/groups/rwr/jtd/IXPEML/'$NN_PREPATH'data_'$SETNUM'_recon_'$SOURCE'-det'$DET'___'$SOURCE'-det'$DET'__ensemble.fits'

if [ -z "${USE_MOM}" ]; then
    export FINAL_FOLDER=$DATA_FOLDER"event_nn"
    export FINAL_FILENAME="ixpe"$CHUNK"_det"$DET"_nn"
    echo "Using NN"
else
    export FINAL_FOLDER=$DATA_FOLDER"event_mom"
    export FINAL_FILENAME="ixpe"$CHUNK"_det"$DET"_l2"
    echo "Using Moments"
fi

date
echo $SOURCE $CHUNK $OBS $DET
