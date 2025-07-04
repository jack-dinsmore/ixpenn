source src/filenames.sh

if [ -z "${TIME_BIN_SIZE}" ]; then 
    TIME_BIN_SIZE=300
    FINAL_TAG="" # This is the default option
else
    FINAL_TAG="_"$TIME_BIN_SIZE
fi

if [ -z "${X_PIX_MEAN}" ]; then 
    X_PIX_MEAN='-'
    Y_PIX_MEAN='-'
fi

echo
echo "Using time bin size" $TIME_BIN_SIZE
echo "Using x_pix_mean" $X_PIX_MEAN
echo "Using y_pix_mean" $Y_PIX_MEAN
echo

cp $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000.fits $DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_bd_int.fits # Note: this centroids the UNCORRECTED FILE and does not boom drift correct. If you want to both boom drift correct AND centroid (which I believe the IXPE pipeline does) you would replace the first filename above with *_j2000_bd.fits instead of *_j2000.fits.
OUTFILE=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_bd_aspcorr.fits

ixpeaspcorr \
    infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_w_adj_j2000_bd_int.fits \
    outfile=$OUTFILE \
    clobber=True \
    n=$TIME_BIN_SIZE \
    attfile_in="$DATA_FOLDER"hk/ixpe"$OBS"_det"$DET"_att_v"$ATTNUM".fits \
    attfile_out=$DATA_FOLDER"$FILENAME"_recon_att_corr.fits \
    x_pix_mean=$X_PIX_MEAN\
    y_pix_mean=$Y_PIX_MEAN\

fparkey $TIME_BIN_SIZE $OUTFILE"[1]" CENTROID comm='The time bin size used for centroiding' add=yes

#######

if [ -z "${USE_MOM}" ]; then
    # NN
    ftcopy $OUTFILE'[EVENTS][col TRG_ID; TIME; STATUS; STATUS2; PI; W_NN; X; Y; Q; U; P_TAIL]' $FINAL_FOLDER"/"$FINAL_FILENAME$FINAL_TAG".fits" clobber=True
else 
    # MOM
    ftcopy $OUTFILE'[EVENTS][col TRG_ID; TIME; STATUS; STATUS2; PI; W_MOM; X; Y; Q; U]' $FINAL_FOLDER"/"$FINAL_FILENAME$FINAL_TAG".fits" clobber=True
fi

#######
