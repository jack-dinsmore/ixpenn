source src/filenames.sh

if [ -z "${USE_MOM}" ]; then
    # NN
    echo "NN" > $DATA_FOLDER"state.txt"
else 
    # Mom
    echo "Mom" > $DATA_FOLDER"state.txt"
fi

echo $NN_FILE

ixpegaincorrtemp \
    infile=$DATA_FOLDER"$FILENAME"_recon.fits \
    outfile=$DATA_FOLDER"$FILENAME"_recon_gain.fits \
    hkfile="$DATA_FOLDER"hk/ixpe"$OBS"_all_pay_132"$DET"_v"$PAYNUM".fits \
    clobber=True \
    logfile=NONE

#######

ixpechrgcorr \
    infile=$DATA_FOLDER"$FILENAME"_recon_gain.fits \
    outfile=$DATA_FOLDER"$FILENAME"_recon_gain_corr.fits \
    initmapfile="$CALDB"/data/ixpe/gpd/bcf/chrgmap/ixpe_d"$DET"_20170101_chrgmap_01.fits \
    outmapfile=$DATA_FOLDER"$FILENAME"_chrgmap.fits \
    phamax=60000.0 \
    clobber=True \
    logfile=NONE

#######

if [ -z "${PPGNUM}" ]; then
    PKGAINFILE="CALDB"
else
    python3 src/gain_manip.py $DATA_FOLDER"auxil/ixpe"$OBS"_det"$DET"_ppg1_v"$PPGNUM".fits"
    PKGAINFILE=$DATA_FOLDER"auxil/ixpe"$OBS"_det"$DET"_ppg1_v"$PPGNUM"_manip.fits"
fi
ixpegaincorrpkmap \
    infile=$DATA_FOLDER"$FILENAME"_recon_gain_corr.fits \
    outfile=$DATA_FOLDER"$FILENAME"_recon_gain_corr_map.fits \
    clobber=True \
    pkgainfile=$PKGAINFILE \
    hvgainfile=CALDB \
    logfile=NONE

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

ixpecalcstokes \
    infile=$DATA_FOLDER"$FILENAME"_recon_nn.fits \
    outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes.fits \
    clobber=True \
    logfile=NONE

#######

ixpeweights \
    infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes.fits \
    outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w.fits \
    clobber=True \
    logfile=NONE

#######

if [ -z "${USE_MOM}" ]; then
    # NN
    ixpeadjmod \
        infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w.fits \
        outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj.fits \
        clobber=True \
        spmodfile=/home/groups/rwr/jtd/IXPEML/caldb/spmod/ixpe_d"$DET"_20170101_spmod_nn.fits \
        logfile=NONE
else
    # MOM
    ixpeadjmod \
        infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w.fits \
        outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj.fits \
        clobber=True \
        logfile=NONE
fi

## Add some missing header values.
yes | fdump $DATA_FOLDER"$RAW_FILENAME".fits["EVENTS"] outfile=STDOUT ROWS=0 | grep TC > $DATA_FOLDER"$FILENAME"wcs.lis
sed -i 's/36 /44 /;s/37 /45 /' $DATA_FOLDER"$FILENAME"wcs.lis
echo -e "TLMIN44 = 0\nTLMAX44 = 600\nTLMIN45 = 0\nTLMAX45 = 600" >> $DATA_FOLDER"$FILENAME"wcs.lis
fthedit $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj.fits["EVENTS"] @$DATA_FOLDER"$FILENAME"wcs.lis

# Delete the wrong status column
echo "STATUS COLUMN CHECKING"
fdelcol $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj.fits[EVENTS] STATUS2 no yes
faddcol $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj.fits[EVENTS] $DATA_FOLDER""$FILENAME"_recon.fits[EVENTS]" STATUS2

##############

echo "start det2j"
echo "$DATA_FOLDER"hk/ixpe"$OBS"_det"$DET"_att_v"$ATTNUM".fits

## Coordinate transformations.
ixpedet2j2000 \
    infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj.fits \
    outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000.fits \
    attfile_in="$DATA_FOLDER"hk/ixpe"$OBS"_det"$DET"_att_v"$ATTNUM".fits \
    clobber=True

echo "stop det2j"

##############

if [ -z "${SRC_RA}" ]; then
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo
    echo "WARNING: You have not set the source ra. The code will fail. Please set the source RA in source_select"
    echo
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

echo Using coordinates $SRC_RA $SRC_DEC

fthedit infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000.fits[0]\
    keyword=RA_OBJ\
    operation=add\
    value=$SRC_RA

fthedit infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000.fits[0]\
    keyword=DEC_OBJ\
    operation=add\
    value=$SRC_DEC

cp $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000.fits $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_int.fits

echo "Starting IXPEBOOMDRIFTCORR"

echo $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_bd.fits
ixpeboomdriftcorr infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_int.fits\
    outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_bd.fits\
    adc0110_file=$DATA_FOLDER"hk/ixpe"$OBS"_all_adc_0110_v"$ADCNUM".fits"\
    attfile_in=$DATA_FOLDER"hk/ixpe"$OBS"_det"$DET"_att_v"$ATTNUM".fits"\
    attfile_out=$DATA_FOLDER"$FILENAME"_att_corrected.fits\
    clobber=yes\
    statout=yes

echo "Did IXPEBOOMDRIFTCORR"

