import numpy as np
from background import get_mask

def correct(l1_filename, nn_filename, recon_file, outfile):
    mask = get_mask(l1_filename, nn_filename, recon_file)
    np.save(outfile, mask)

if __name__ == "__main__":
    recon_file = "data/sim/recon/ixpe_pd1_spec2_ang0_det1_evt1_v01_recon.fits"
    l1_filename = "data/sim/event_l1/ixpe_pd1_spec2_ang0_det1_evt1_v01.fits"
    nn_filename = "../jtd/IXPEML/_home_groups_rwr_ixpenn_data_sim_recon_sim-det1___sim-det1__ensemble.fits"
    outfile = "data/sim/event_mom/bkg-mask.npy"
    correct(l1_filename, nn_filename, recon_file, outfile)

