import numpy as np
from matplotlib import pyplot as plt
from astropy.io import fits
import sys, os, copy

def get_data_path(obs_id, det, ours=True):
    if ours:
        mobs_id = f"m{obs_id[1:]}"
        filename=f"{'/'.join(__file__.split('/')[:-2])}/data/{mobs_id}/recon/ixpe{obs_id}_det1_evt1_v02_recon_gain_corr_map.fits"
    else:
        filename=f"{'/'.join(__file__.split('/')[:-2])}/data/{obs_id}/event_l2/ixpe{obs_id}_det1_evt2_v01.fits"
    return filename

def display_columns(obs_id):
    path = get_data_path(obs_id, det=1)
    with fits.open(path) as hdul:
        print(hdul[1].data.columns)

def plot_hist(obs_id, col, det=1):
    path = get_data_path(obs_id, det=det, ours=True)
    with fits.open(path) as hdul:
        our_mom_data = hdul[1].data[col]

    path = get_data_path(obs_id, det=det, ours=False)
    with fits.open(path) as hdul:
        ixpe_mom_data = hdul[1].data[col]

    fig, ax = plt.subplots()
    bins = np.linspace(np.nanpercentile(our_mom_data, 1), np.nanpercentile(our_mom_data, 99), 51)
    ax.hist(our_mom_data, bins=bins, color="C1", histtype="step", label="Our Mom")
    ax.hist(ixpe_mom_data, bins=bins, color="C2", histtype="step", label="IXPE L2 (Mom)")
    ax.legend()
    ax.set_xlabel(col)
    ax.set_ylabel("Counts")
    fig.suptitle(f"{obs_id} (intermediate)")
    fig.savefig(f"figs/intermediate-{obs_id}-{col}.png")

if __name__ == "__main__":
    obs_id = sys.argv[1]
    display_columns(obs_id)
    plot_hist(obs_id, "PI")
