source src/filenames.sh

    
L1_FILE=$DATA_FOLDER"$RAW_FILENAME".fits
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
echo Running file $FILE_CORE

echo

python3 leakagelib/flag_background.py "$FILE_CORE".fits $L1_FILE "$FILE_CORE"_bkg.fits
