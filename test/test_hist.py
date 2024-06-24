import numpy as np
from matplotlib import pyplot as plt
from astropy.io import fits
import sys, os

def get_data_path(obs_id, det, nn=True, ours=True):
    if nn:
        event_dir = "event_nn"
    else:
        if ours:
            event_dir = "event_mom"
        else:
            event_dir = "event_l2"
    data_dir = f"{'/'.join(__file__.split('/')[:-2])}/data/{obs_id}/{event_dir}"
    for f in os.listdir(data_dir):
        if f"det{det}" in f:
            return f"{data_dir}/{f}"

def display_columns(obs_id):
    path = get_data_path(obs_id, det=1, nn=True)
    with fits.open(path) as hdul:
        print(hdul[1].data.columns)

def plot_hist(obs_id, col, det=1):
    path = get_data_path(obs_id, det=det, nn=True)
    with fits.open(path) as hdul:
        nn_data = hdul[1].data[col]

    path = get_data_path(obs_id, det=det, nn=False, ours=True)
    with fits.open(path) as hdul:
        our_mom_data = hdul[1].data[col]

    path = get_data_path(obs_id, det=det, nn=False, ours=False)
    with fits.open(path) as hdul:
        ixpe_mom_data = hdul[1].data[col]

    fig, ax = plt.subplots()
    bins = np.linspace(np.nanpercentile(nn_data, 1), np.nanpercentile(nn_data, 99), 51)
    ax.hist(nn_data, bins=bins, color="C0", histtype="step", label="NN")
    ax.hist(our_mom_data, bins=bins, color="C1", histtype="step", label="Our Mom")
    ax.hist(ixpe_mom_data, bins=bins, color="C1", histtype="step", label="IXPE L2 (Mom)")
    ax.legend()
    ax.set_xlabel(col)
    ax.set_ylabel("Counts")
    fig.suptitle(str(obs_id))
    fig.savefig(f"figs/{obs_id}-{col}.png")

if __name__ == "__main__":
    obs_id = sys.argv[1]
    display_columns(obs_id)
    plot_hist(obs_id, "X")
    plot_hist(obs_id, "Y")
    plot_hist(obs_id, "PI")
