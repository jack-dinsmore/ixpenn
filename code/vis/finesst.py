# Generate figures for the FINESST proposal
import numpy as np
from astropy.io import fits
import matplotlib.pyplot as plt
from code.vis.vis import vis
from dinsmore.plt import diagram_arrow

plt.style.use("root")
STATUS_MASK = [True,False,True,True,True,True,True,True,True,True,True,True,False,True,True,False]

def load_single(filename, l2_filename, track_indices):
    fig, axs = plt.subplots(figsize=(5, 3), ncols=len(track_indices), sharex=True, sharey=True)

    with fits.open(filename, memmap=True) as hdul:
        # Load the event
        data = hdul[1].data
        if "STATUS2" in data.columns.names:
            flagged = np.any(data["STATUS2"] & STATUS_MASK, axis=1)
        else:
            flagged = np.zeros(len(data["MIN_CHIPX"])).astype(bool)
        
        for ax, track_index in zip(axs, track_indices):
            dist = np.sqrt((data["X"][~flagged][track_index] - 300)**2 + (data["X"][~flagged][track_index]- 300)**2)
            min_x = data["MIN_CHIPX"][~flagged][track_index]
            min_y = data["MIN_CHIPY"][~flagged][track_index]
            max_x = data["MAX_CHIPX"][~flagged][track_index]
            max_y = data["MAX_CHIPY"][~flagged][track_index]
            track = data["PIX_PHAS"][~flagged][track_index].reshape(max_y-min_y+1, max_x-min_x+1).astype(float)

            track -= 28
            track[track <= 0] = np.nan

            vis(track, ax, size=38, offset=False)
            ax.set_aspect("equal")
            ax.spines[:].set_visible(False)
            ax.set_xticks([])
            ax.set_yticks([])
            ax.set_xlim(-10, 10)
            ax.set_ylim(-10, 10)

    with fits.open(l2_filename, memmap=True) as hdul:
        # Load the event
        data = hdul[1].data
        q = data["Q"][track_indices[0]]
        u = data["U"][track_indices[0]]
        pa = np.arctan2(u, q) / 2

    offset_x = 1.2
    axs[0].plot([-10 * np.sin(pa)-offset_x, 10 * np.sin(pa)-offset_x], [10 * np.cos(pa), -10 * np.cos(pa)], color='k', lw=1)
    axs[0].text(-2 * np.sin(pa)-offset_x, 2 * np.cos(pa), "EVPA", ha="center", va="top", rotation=pa*180/np.pi-90)
    axs[0].scatter(4 * np.sin(pa)-offset_x, -4 * np.cos(pa), marker='o', edgecolor='k', facecolor='none', s=108)

    axs[0].set_title("Photon track", size=12)
    axs[1].set_title("Particle track", size=12)

    diagram_arrow(axs[0], [7.5, 1], [4 * np.sin(pa)-offset_x+0.9, -4 * np.cos(pa)+0.9], aspect=-0.3, head_scale=0.05)
    axs[0].text(7.5, 1, "Conversion\npoint", ha="center", va="bottom")

    fig.savefig(f"figs/finesst-track.png")
    fig.savefig(f"figs/finesst-track.pdf")

if __name__ == "__main__":
    load_single("../data/01002601/event_l1/ixpe01002601_det1_evt1_v02.fits", "../data/01002601/my_event_l2/ixpe01002601_det1_l2.fits", (
        1159,
        681,
    ))