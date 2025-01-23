source src/filenames.sh

echo $NN_FILE

ixpegaincorrtemp infile=$DATA_FOLDER"$FILENAME"_recon.fits outfile=$DATA_FOLDER"$FILENAME"_recon_gain.fits hkfile="$DATA_FOLDER"hk/ixpe"$OBS"_all_pay_132"$DET"_v"$PAYNUM".fits clobber=True logfile=NONE

#######

ixpechrgcorr infile=$DATA_FOLDER"$FILENAME"_recon_gain.fits outfile=$DATA_FOLDER"$FILENAME"_recon_gain_corr.fits initmapfile="$CALDB"/data/ixpe/gpd/bcf/chrgmap/ixpe_d"$DET"_20170101_chrgmap_01.fits outmapfile=$DATA_FOLDER"$FILENAME"_chrgmap.fits phamax=60000.0 clobber=True logfile=NONE

#######

ixpegaincorrpkmap infile=$DATA_FOLDER"$FILENAME"_recon_gain_corr.fits outfile=$DATA_FOLDER"$FILENAME"_recon_gain_corr_map.fits clobber=True pkgainfile=$DATA_FOLDER"auxil/ixpe"$OBS"_det"$DET"_ppg1_v"$PPGNUM".fits" hvgainfile=CALDB logfile=NONE

python3 src/test.py $DATA_FOLDER"$FILENAME"_recon_gain_corr_map.fits

#######

if [ -z "${USE_MOM}" ]; then
    # NN
    python3 src/write.py $DATA_FOLDER"$FILENAME"'_recon_gain_corr_map.fits' $NN_FILE $DATA_FOLDER"$FILENAME"_recon_nn.fits
else
    # MOM
    cp $DATA_FOLDER"$FILENAME"'_recon_gain_corr_map.fits' $DATA_FOLDER"$FILENAME"_recon_nn.fits
fi

#######

ixpecalcstokes infile=$DATA_FOLDER"$FILENAME"_recon_nn.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes.fits clobber=True logfile=NONE

#######

ixpeweights infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w.fits clobber=True logfile=NONE

#######

if [ -z "${USE_MOM}" ]; then
    # NN
    ixpeadjmod infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj.fits clobber=True spmodfile=/home/groups/rwr/jtd/IXPEML/caldb/spmod/ixpe_d"$DET"_20170101_spmod_nn.fits logfile=NONE
else
    # MOM
    ixpeadjmod infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj.fits clobber=True logfile=NONE
fi

## Add some missing header values.
sed -i 's/36 /44 /;s/37 /45 /' $DATA_FOLDER"$FILENAME"wcs.lis
echo -e "TLMIN44 = 0\nTLMAX44 = 600\nTLMIN45 = 0\nTLMAX45 = 600" >> $DATA_FOLDER"$FILENAME"wcs.lis
fthedit $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj.fits["EVENTS"] @$DATA_FOLDER"$FILENAME"wcs.lis

# Delete the events with the wrong status
fdelcol $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj.fits[EVENTS] STATUS2 no yes
faddcol $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj.fits[EVENTS] $DATA_FOLDER""$FILENAME"_recon.fits[EVENTS]" STATUS2

