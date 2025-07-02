source src/filenames.sh

if [ -z "${USE_MOM}" ]; then
    # NN
    echo "NN" > $DATA_FOLDER"state.txt"
else 
    # Mom
    echo "Mom" > $DATA_FOLDER"state.txt"
fi

echo $NN_FILE

cp $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000.fits $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_int.fits

echo "Starting IXPEBOOMDRIFTCORR"

echo $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_bd.fits
echo $DATA_FOLDER"hk/ixpe"$OBS"_all_adc_0110_v"$ADCNUM".fits"
echo $DATA_FOLDER"hk/ixpe"$OBS"_det"$DET"_att_v"$ATTNUM".fits"
echo $DATA_FOLDER"$FILENAME"_att_corrected.fits
ixpeboomdriftcorr infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_int.fits\
    outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_bd.fits\
    adc0110_file=$DATA_FOLDER"hk/ixpe"$OBS"_all_adc_0110_v"$ADCNUM".fits"\
    attfile_in=$DATA_FOLDER"hk/ixpe"$OBS"_det"$DET"_att_v"$ATTNUM".fits"\
    attfile_out=$DATA_FOLDER"$FILENAME"_att_corrected.fits\
    clobber=yes\
    statout=yes

echo "Did IXPEBOOMDRIFTCORR"

