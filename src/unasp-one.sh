source src/filenames.sh

if [ -z "${SRC_RA}" ]; then
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo
    echo "WARNING: You have not set the source ra. The code will fail. Please set the source RA in source_select"
    echo 
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

echo Using coordinates $SRC_RA $SRC_DEC

if [ -z "${USE_MOM}" ]; then
    # NN
    ftcopy $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000.fits'[EVENTS][col TRG_ID; TIME; STATUS; STATUS2; PI; W_MOM; W_NN; X; Y; Q; U; P_TAIL]' $FINAL_FOLDER/"$FINAL_FILENAME"_uncorr.fits clobber=True
    ftcopy $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_bd.fits'[EVENTS][col TRG_ID; TIME; STATUS; STATUS2; PI; W_MOM; W_NN; X; Y; Q; U; P_TAIL]' $FINAL_FOLDER/"$FINAL_FILENAME"_boom.fits clobber=True
else
    # MOM
    ftcopy $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000.fits'[EVENTS][col TRG_ID; TIME; STATUS; STATUS2; PI; W_MOM; X; Y; Q; U]' $FINAL_FOLDER/"$FINAL_FILENAME"_uncorr.fits clobber=True
    ftcopy $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_bd.fits'[EVENTS][col TRG_ID; TIME; STATUS; STATUS2; PI; W_MOM; X; Y; Q; U]' $FINAL_FOLDER/"$FINAL_FILENAME"_boom.fits clobber=True
fi

