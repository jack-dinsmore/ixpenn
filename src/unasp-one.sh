source src/filenames.sh

fthedit infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_int.fits[0]\
    keyword=RA_OBJ\
    operation=add\
    value="17.7726417"

fthedit infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_int.fits[0]\
    keyword=DEC_OBJ\
    operation=add\
    value="-28.8823611"

ixpeboomdriftcorr infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_int.fits\
    outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_bd.fits\
    adc0110_file=$DATA_FOLDER"hk/ixpe"$OBS"_all_adc_0110_v01.fits"\
    attfile_in=$DATA_FOLDER"hk/ixpe"$OBS"_det"$DET"_att_v"$ATTNUM".fits"\
    attfile_out=$DATA_FOLDER"$FILENAME"_att_corrected.fits\
    clobber=yes

if [ -z "${USE_MOM}" ]; then
    # NN
    ftcopy $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_int.fits'[EVENTS][col TRG_ID; TIME; STATUS; STATUS2; PI; W_MOM; W_NN; X; Y; Q; U]' $FINAL_FOLDER/"$FINAL_FILENAME"_uncorr.fits clobber=True
    ftcopy $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_bd.fits'[EVENTS][col TRG_ID; TIME; STATUS; STATUS2; PI; W_MOM; W_NN; X; Y; Q; U]' $FINAL_FOLDER/"$FINAL_FILENAME"_boom.fits clobber=True
else
    # MOM
    ftcopy $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_int.fits'[EVENTS][col TRG_ID; TIME; STATUS; STATUS2; PI; W_MOM; X; Y; Q; U]' $FINAL_FOLDER/"$FINAL_FILENAME"_uncorr.fits clobber=True
    ftcopy $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_bd.fits'[EVENTS][col TRG_ID; TIME; STATUS; STATUS2; PI; W_MOM; X; Y; Q; U]' $FINAL_FOLDER/"$FINAL_FILENAME"_boom.fits clobber=True
fi

