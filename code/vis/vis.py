import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits
import sys
sys.path.append("../nn")
from train import evaluate_model

plt.style.use("root")

def vis(track, ax, size=48, offset=True):
    height, width = track.shape
    x_line = np.arange(width+1).astype(float)
    y_line = np.arange(height+1) * 0.866
    x_line -= np.mean(x_line)
    y_line -= np.mean(y_line)

    x_centers = (x_line[1:] + x_line[:-1]) / 2
    y_centers = (y_line[1:] + y_line[:-1]) / 2

    # Display the image
    cmap = plt.get_cmap("RdPu")
    xs_grid, ys_grid = np.meshgrid(x_centers, y_centers)
    if offset:
        xs_grid[1::2,:] += (x_line[1] - x_line[0]) / 2
    else:
        xs_grid[0::2,:] += (x_line[1] - x_line[0]) / 2

    min_count = 0
    max_count = np.nanmax(track)
    image = track.reshape(-1)
    # image = image[mask]
    # xs_grid = xs_grid.reshape(-1)[mask]
    # ys_grid = ys_grid.reshape(-1)[mask]
    colors = cmap((image - min_count) / (max_count - min_count))
    colors[image <= min_count] = (1,1,1,1)
    ax.scatter(xs_grid, ys_grid, marker='h', color=colors, s=size, zorder=-2)
    ax.set_aspect("equal")

def vis_array(tracks, n, out="track-grid", use_model=False):
    l = int(np.sqrt(n))
    fig, axs = plt.subplots(figsize=(1.5*l,1.5*l), ncols=l, nrows=l, sharex=True, sharey=True)
    for track, ax in zip(tracks[:n], axs.reshape(-1)):
        vis(track, ax, size=4)
        ax.axis(False)
    fig.subplots_adjust(hspace=0.05, wspace=0.05)

    if use_model:
        # Put rectangles around the tracks which are background
        probabilities = evaluate_model(tracks[:n])
        for (prob, ax) in zip(probabilities, axs.reshape(-1)):
            prob=float(prob)
            ax.plot([0, 0], [0, 1], transform=ax.transAxes, color='r', alpha=prob, lw=1)
            ax.plot([1, 1], [0, 1], transform=ax.transAxes, color='r', alpha=prob, lw=1)
            ax.plot([0, 1], [0, 0], transform=ax.transAxes, color='r', alpha=prob, lw=1)
            ax.plot([0, 1], [1, 1], transform=ax.transAxes, color='r', alpha=prob, lw=1)
            if prob > 0.0005:
                ax.text(0.5, 1, f"{prob*100:.1f}%", ha="center", va="top", size=12, transform=ax.transAxes)
    fig.savefig(f"figs/{out}.png")

if __name__ == "__main__":
    bg_tracks = np.load("../nn/data/background0.npy")
    np.random.shuffle(bg_tracks)
    vis_array(bg_tracks, 100, out="bg", use_model=True)
    
    src_tracks = np.load("../nn/data/source0.npy")
    np.random.shuffle(src_tracks)
    vis_array(src_tracks, 100, out="src", use_model=True)