# Prove the particles with incorrect NN energies are background
import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits

plt.style.use("root")

fig, ax = plt.subplots()

bin_edges = np.linspace(1, 10, 50)
bin_centers = (bin_edges[1:] + bin_edges[:-1]) / 2
pi_density = np.histogram(np.arange(1024) * 0.04 + 0.02, bin_edges)[0]

with fits.open("data/02008801/event_nn_nn_energies/ixpe02008801_det1_nn.fits") as hdul:
    energies = hdul[1].data["PI"] * 0.04 + 0.02
    xs = hdul[1].data["X"]-305
    ys = hdul[1].data["Y"]-301
    src_mask = xs**2 + ys**2 < 10**2
    bg_mask = xs**2 + ys**2 > 30**2
    energy_counts_bg = np.histogram(energies[bg_mask], bin_edges)[0].astype(float)
    energy_counts_src = np.histogram(energies[src_mask], bin_edges)[0].astype(float)
    ax.plot(bin_centers, energy_counts_src / pi_density, label="NN (src)", color='r')
    ax.plot(bin_centers, energy_counts_bg / pi_density, ls="dashed", label="NN (bg)", color='r')

with fits.open("data/02008801/my_event_l2/ixpe02008801_det1_l2.fits") as hdul:
    energies = hdul[1].data["PI"] * 0.04 + 0.02
    xs = hdul[1].data["X"]-305
    ys = hdul[1].data["Y"]-301
    src_mask = xs**2 + ys**2 < 10**2
    bg_mask = xs**2 + ys**2 > 30**2
    energy_counts_bg = np.histogram(energies[bg_mask], bin_edges)[0].astype(float)
    energy_counts_src = np.histogram(energies[src_mask], bin_edges)[0].astype(float)
    energy_counts = np.histogram(energies, bin_edges)[0].astype(float)
    ax.plot(bin_centers, energy_counts_src / pi_density, label="Mom (src)", color='b')
    ax.plot(bin_centers, energy_counts_bg / pi_density, ls="dashed", label="Mom (bg)", color='b')

ax.axvline(2, color='k', ls='dotted', lw=1)
ax.axvline(8, color='k', ls='dotted', lw=1)

ax.legend(loc="lower left")
ax.set_xlabel("Energy [keV]")
ax.set_ylabel("Counts")
ax.set_xscale("log")
ax.set_yscale("log")
fig.savefig("energies.png")