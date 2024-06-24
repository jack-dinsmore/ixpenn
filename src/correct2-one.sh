## Coordinate transformations.
ixpedet2j2000 infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w_j2000.fits attfile_in="$DATA_FOLDER"hk/ixpe"$OBS"_det"$DET"_att_v"$ATTNUM".fits clobber=True

#######

cp $DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w_j2000.fits $DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w_j2000_int.fits

echo "About to start ixpeaspcorr"
ixpeaspcorr infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w_j2000.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w_j2000_aspcorr.fits clobber=True n=300 attfile_in="$DATA_FOLDER"hk/ixpe"$OBS"_det"$DET"_att_v"$ATTNUM".fits attfile_out=$DATA_FOLDER"$FILENAME"_recon_att_corr.fits


#######

ftcopy $DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w_j2000_aspcorr.fits'[EVENTS][col TRG_ID; TIME; STATUS; STATUS2; PI; W_MOM; W_NN; X; Y; Q; U]' $FINAL_FOLDER/"$FINAL_FILENAME".fits clobber=True

#######
