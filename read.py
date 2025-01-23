import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits

with fits.open("data/02001299/recon/ixpe02001201_det1_evt1_v03_recon_gain_corr_map.fits") as hdul:
    energies = 0.02 + 0.04 * hdul[1].data["PI"]
    fig, ax = plt.subplots()
    ax.hist(energies, np.linspace(1, 12, 100))

with fits.open("/home/groups/rwr/jtd/IXPEML/_home_groups_rwr_plindholm_ixpenn_data_02001299_recon_b05401-det1___b05401-det1__ensemble.fits") as hdul:
    ax.hist(hdul[1].data["NN_ENERGY"], np.linspace(1, 12, 100))

fig.savefig("energies.png")
