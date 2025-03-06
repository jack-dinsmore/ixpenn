# mkdir ../../data/01002601/event_nn_bkg
# python clean.py ../../data/01002601/event_l1/ixpe01002601_det1_evt1_v02.fits ../../data/01002601/event_nn/ixpe01002601_det1_nn.fits ../../data/01002601/event_nn_bkg/ixpe01002601_det1_nn.fits
# python clean.py ../../data/01002601/event_l1/ixpe01002601_det2_evt1_v02.fits ../../data/01002601/event_nn/ixpe01002601_det2_nn.fits ../../data/01002601/event_nn_bkg/ixpe01002601_det2_nn.fits
# python clean.py ../../data/01002601/event_l1/ixpe01002601_det3_evt1_v02.fits ../../data/01002601/event_nn/ixpe01002601_det3_nn.fits ../../data/01002601/event_nn_bkg/ixpe01002601_det3_nn.fits
# python ixpe_merge.py ../../data/01002601/event_nn_bkg/* ../../data/01002601/event_nn_bkg/ixpe01002601_all_nn.fits

# mkdir ../../data/02250101/event_nn_bkg
python clean.py ../../data/02250101/event_l1/ixpe02250101_det1_evt1_v03.fits ../../data/02250101/event_nn/ixpe02250101_det1_nn.fits ../../data/02250101/event_nn_bkg/ixpe02250101_det1_nn.fits
python clean.py ../../data/02250101/event_l1/ixpe02250101_det2_evt1_v02.fits ../../data/02250101/event_nn/ixpe02250101_det2_nn.fits ../../data/02250101/event_nn_bkg/ixpe02250101_det2_nn.fits
python clean.py ../../data/02250101/event_l1/ixpe02250101_det3_evt1_v02.fits ../../data/02250101/event_nn/ixpe02250101_det3_nn.fits ../../data/02250101/event_nn_bkg/ixpe02250101_det3_nn.fits
python ixpe_merge.py ../../data/02250101/event_nn_bkg/* ../../data/02250101/event_nn_bkg/ixpe02250101_all_nn.fits


# mkdir ../../data/02008801/event_nn_bkg
python clean.py ../../data/02008801/event_l1/ixpe02008801_det1_evt1_v01.fits ../../data/02008801/nobkgcorr/ixpe02008801_det1_nn.fits ../../data/02008801/event_nn_bkg/ixpe02008801_det1_nn.fits
python clean.py ../../data/02008801/event_l1/ixpe02008801_det2_evt1_v01.fits ../../data/02008801/nobkgcorr/ixpe02008801_det2_nn.fits ../../data/02008801/event_nn_bkg/ixpe02008801_det2_nn.fits
python clean.py ../../data/02008801/event_l1/ixpe02008801_det3_evt1_v01.fits ../../data/02008801/nobkgcorr/ixpe02008801_det3_nn.fits ../../data/02008801/event_nn_bkg/ixpe02008801_det3_nn.fits
python ixpe_merge.py ../../data/02008801/event_nn_bkg/* ../../data/02008801/event_nn_bkg/ixpe02008801_all_nn.fits
