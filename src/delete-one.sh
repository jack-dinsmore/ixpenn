########

# Replace the status2 column
fdelcol $DATA_FOLDER"$FILENAME"_recon.fits[EVENTS] STATUS2 no yes
faddcol $DATA_FOLDER"$FILENAME"_recon.fits[EVENTS] $DATA_FOLDER"$FILENAME".fits[EVENTS] STATUS2

########

# Add some missing header values
fdump $DATA_FOLDER"$RAW_FILENAME".fits[0] tmp.lis - 1 prdata=yes showcol=no
grep -i S_VDRIFT tmp.lis >> fix.lis
grep -i S_VBOT tmp.lis >> fix.lis
grep -I S_VGEM tmp.lis >> fix.lis
echo "FILE_LVL = '1'" >> fix.lis

fmodhead $DATA_FOLDER"$FILENAME"_recon.fits fix.lis
rm tmp.lis fix.lis

yes | ftlist $DATA_FOLDER"$RAW_FILENAME".fits["EVENTS"] outfile=STDOUT ROWS=0 | grep TC > $DATA_FOLDER"$FILENAME"wcs.lis

########

# Remove the hefty columns from the _recon files
python3 -u src/recon_trim.py $DATA_FOLDER"$FILENAME"_recon.fits
python3 -u src/hack-fits.py $DATA_FOLDER"$FILENAME"'_recon.fits'

########

# Remove all the old raw data
rm $DATA_FOLDER"$FILENAME".fits

########

# Remove the NN track records
rm -r $NN_FOLDER

