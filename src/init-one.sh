#!/bin/bash
set -e

source filenames.sh

ftcopy $DATA_FOLDER"$RAW_FILENAME"'.fits[EVENTS][STATUS2 == b0x0000000000x00x]' $DATA_FOLDER"$FILENAME"'.fits' clobber=True

ixpeevtrecon infile=$DATA_FOLDER"$FILENAME".fits outfile=$DATA_FOLDER$FILENAME'_recon.fits' clobber=True writeTracks=True 1> /dev/null 

# Add some missing header values.
fdump $DATA_FOLDER"$RAW_FILENAME".fits[1] tmp.lis - 1 prdata=yes showcol=no
grep -i S_VDRIFT tmp.lis >> fix.lis
grep -i S_VBOT tmp.lis >> fix.lis
grep -I S_VGEM tmp.lis >> fix.lis
echo "FILE_LVL = '1'" >> fix.lis

fthedit $DATA_FOLDER"$FILENAME"_recon.fits @fix.lis
rm tmp.lis fix.lis

