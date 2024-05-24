source src/filenames.sh

case $DET in 
    1)
        PAYNUM=$PAYNUM1
        ;;
    2)
        PAYNUM=$PAYNUM2
        ;;
    3)
        PAYNUM=$PAYNUM3
        ;;
    *)
        echo "Could not recognize detector"
        ;;
esac

ixpegaincorrtemp infile=$DATA_FOLDER"$FILENAME"_recon.fits outfile=$DATA_FOLDER"$FILENAME"_recon_gain.fits hkfile="$DATA_FOLDER"hk/ixpe"$OBS"_all_pay_132"$DET"_v"$PAYNUM".fits clobber=True

#######

ixpechrgcorr infile=$DATA_FOLDER"$FILENAME"_recon_gain.fits outfile=$DATA_FOLDER"$FILENAME"_recon_gain_corr.fits initmapfile="$CALDB"/data/ixpe/gpd/bcf/chrgmap/ixpe_d"$DET"_20170101_chrgmap_01.fits outmapfile=$DATA_FOLDER"$FILENAME"_chrgmap.fits phamax=60000.0 clobber=True

#######

export HEADAS=/home/groups/rwr/alpv95/tracksml/moments/heasoft-6.30.1/x86_64-pc-linux-gnu-libc2.17
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

ixpegaincorrpkmap infile=$DATA_FOLDER"$FILENAME"_recon_gain_corr.fits outfile=$DATA_FOLDER"$FILENAME"_recon_gain_corr_map.fits clobber=True pkgainfile=CALDB hvgainfile=CALDB

python3 src/test.py $DATA_FOLDER"$FILENAME"_recon_gain_corr_map.fits

export HEADAS=/home/groups/rwr/jtd/heasoft-6.32.1/x86_64-pc-linux-gnu-libc2.17
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

#######

if [ -z "${USE_MOM}" ]; then
    # NN
    python3 src/write.py $DATA_FOLDER"$FILENAME"'_recon_gain_corr_map.fits' $NN_FILE $DATA_FOLDER"$FILENAME"_recon_nn.fits
else
    # MOM
    cp $DATA_FOLDER"$FILENAME"'_recon_gain_corr_map.fits' $DATA_FOLDER"$FILENAME"_recon_nn.fits
fi

#######

ixpecalcstokes infile=$DATA_FOLDER"$FILENAME"_recon_nn.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes.fits clobber=True

#######

if [ -z "${USE_MOM}" ]; then
    # NN
    ixpeadjmod infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj.fits clobber=True spmodfile="$PREFIX"caldb/spmod/ixpe_d"$DET"_20170101_spmod_nn.fits
else
    # MOM
    ixpeadjmod infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj.fits clobber=True
fi

#######

ixpeweights infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w.fits clobber=True

#######

## Add some missing header values.
sed -i 's/36 /44 /;s/37 /45 /' $DATA_FOLDER"$FILENAME"wcs.lis
echo -e "TLMIN44 = 1\nTLMAX44 = 600\nTLMIN45 = 1\nTLMAX45 = 600" >> $DATA_FOLDER"$FILENAME"wcs.lis
fthedit $DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w.fits["EVENTS"] @$DATA_FOLDER"$FILENAME"wcs.lis

# Delete the events with the wrong status
fdelcol $DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w.fits[EVENTS] STATUS2 no yes
faddcol $DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w.fits[EVENTS] $DATA_FOLDER""$FILENAME"_recon.fits[EVENTS]" STATUS2

