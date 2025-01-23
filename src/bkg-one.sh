source src/filenames.sh

    
L1_FILE=$DATA_FOLDER"$RAW_FILENAME".fits
PK_MAP_FILE=$DATA_FOLDER"$FILENAME"_recon_gain_corr_map.fits
FILE_CORE=$FINAL_FOLDER/"$FINAL_FILENAME"

if [ -z "${USE_UNCORR}" ]; then
    echo "Not using uncorr"
else
    FILE_CORE=$FILE_CORE"_uncorr"
fi
if [ -z "${USE_BOOM}" ]; then
    echo "Not using boom"
else
    FILE_CORE=$FILE_CORE"_boom"
fi

echo

python3 src/background.py $L1_FILE $PK_MAP_FILE "$FILE_CORE".fits "$FILE_CORE"_bkg.fits
