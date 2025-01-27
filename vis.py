import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits
from load import load_tracks

plt.style.use("root")

def vis(track, ax):
    height, width = track.shape
    x_line = np.arange(width+1)
    y_line = np.arange(height+1) * 0.866

    x_centers = (x_line[1:] + x_line[:-1]) / 2
    y_centers = (y_line[1:] + y_line[:-1]) / 2

    # Display the image
    cmap = plt.get_cmap("RdPu")
    xs_grid, ys_grid = np.meshgrid(x_centers, y_centers)
    xs_grid[1::2,:] += (x_line[1] - x_line[0]) / 2

    min_count = 0
    max_count = np.max(track)
    image = track.reshape(-1)
    mask = image > min_count
    # image = image[mask]
    # xs_grid = xs_grid.reshape(-1)[mask]
    # ys_grid = ys_grid.reshape(-1)[mask]
    colors = cmap((image - min_count) / (max_count - min_count))
    ax.scatter(xs_grid, ys_grid, marker='h', color=colors, s=48, zorder=-2)
    ax.set_aspect("equal")


def vis_one(datafile):
    tracks = load_tracks(datafile, max_lim=10)

    fig, ax = plt.subplots(figsize=(2,2))
    index = np.random.randint(len(tracks))
    vis(tracks[index], ax)
    fig.savefig("figs/track.png")

def vis_array(tracks, n, labels=None, out="track-grid"):
    if labels is None: labels = [""] * n
    l = int(np.sqrt(n))
    fig, axs = plt.subplots(figsize=(1.5*l,1.5*0.866*l), ncols=l, nrows=l, sharex=True, sharey=True)
    for track, ax, label in zip(tracks[:n], axs.reshape(-1), labels):
        vis(track, ax)
        ax.text(0.5, 1, label, ha="center", va="top", size=16, transform=ax.transAxes)
        ax.axis(False)
    fig.subplots_adjust(hspace=0, wspace=0)
    fig.savefig(f"figs/{out}.png")

if __name__ == "__main__":
    clean_tracks = load_tracks("data/01002601/event_l1/ixpe01002601_det1_evt1_v02.fits", 100,
        position_filter=(300, 305, 5)
    )
    vis_array(clean_tracks, 100, np.arange(100), out="on-ax")
        
    unclean_tracks = load_tracks("data/01002601/event_l1/ixpe01002601_det1_evt1_v02.fits", 100,
        position_filter=(300, 305, -45)
    )
    vis_array(unclean_tracks, 100, np.arange(100), out="off-ax")