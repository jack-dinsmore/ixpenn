#!/bin/bash
#set -e

source src/filenames.sh
mkdir -p $DATA_FOLDER"recon"

if [ -z "${USE_MOM}" ]; then
    mkdir -p $DATA_FOLDER"event_nn"
else
    mkdir -p $DATA_FOLDER"event_mom"
fi

# Copy the whole file, in case the next copy fails
ftcopy $DATA_FOLDER"$RAW_FILENAME"'.fits[EVENTS]' $DATA_FOLDER"$FILENAME"'.fits' clobber=True
# Copy just the good events

# If the source is a simulation, do not correct pixeq
if [[ "$SETNUM" == "sim" ]]; then
    ixpeevtrecon infile=$DATA_FOLDER"$FILENAME".fits outfile=$DATA_FOLDER$FILENAME'_recon.fits' clobber=True logfile=/dev/null writeTracks=True pixeqfile=NONE CoherentNoiseOffset=NONE TriggerMiniclusterOffset=NONE
else
    ftcopy $DATA_FOLDER"$RAW_FILENAME"'.fits[EVENTS][STATUS2 == b0x0000000000x00x]' $DATA_FOLDER"$FILENAME"'.fits' clobber=True

    if [ -z "${USE_MOM}" ]; then
        ixpeevtrecon infile=$DATA_FOLDER"$FILENAME".fits outfile=$DATA_FOLDER$FILENAME'_recon.fits' clobber=True logfile=/dev/null writeTracks=True
    else
        ixpeevtrecon infile=$DATA_FOLDER"$FILENAME".fits outfile=$DATA_FOLDER$FILENAME'_recon.fits' clobber=True logfile=/dev/null
    fi
fi

# Add some missing header values.
fdump $DATA_FOLDER"$RAW_FILENAME".fits[1] tmp.lis - 1 prdata=yes showcol=no
grep -i S_VDRIFT tmp.lis >> fix.lis
grep -i S_VBOT tmp.lis >> fix.lis
grep -I S_VGEM tmp.lis >> fix.lis
echo "FILE_LVL = '1'" >> fix.lis

fthedit $DATA_FOLDER"$FILENAME"_recon.fits @fix.lis
rm tmp.lis fix.lis

