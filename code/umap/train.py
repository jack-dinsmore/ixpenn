import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits
#from sklearn.preprocessing import StandardScaler
import umap
from code.vis.vis import vis_array, vis
from code.common.load import load_tracks

plt.style.use("root")

def build_map(tracks):
    reducer = umap.UMAP(random_state=42)
    reducer.fit(tracks.reshape(tracks.shape[0], -1))
    print("Reducer fitted")
    embedding = reducer.transform(tracks.reshape(tracks.shape[0], -1))
    assert(np.all(embedding == reducer.embedding_))
    return reducer


def discriminate(reducer, tracks1, tracks2, tracks3, outtag="", labels=["", "", ""]):
    embedding1 = reducer.transform(tracks1.reshape(tracks1.shape[0], -1))
    embedding2 = reducer.transform(tracks2.reshape(tracks2.shape[0], -1))
    embedding3 = reducer.transform(tracks3.reshape(tracks3.shape[0], -1))

    x_line = np.arange(
        min(np.min(embedding1[:,0]), np.min(embedding2[:,0]), np.min(embedding3[:,0])),
        max(np.max(embedding1[:,0]), np.max(embedding2[:,0]), np.max(embedding3[:,0])),
        0.2)
    y_line = np.arange(
        min(np.min(embedding1[:,1]), np.min(embedding2[:,1]), np.min(embedding3[:,1])),
        max(np.max(embedding1[:,1]), np.max(embedding2[:,1]), np.max(embedding3[:,1])),
        0.2)
    fig, axs = plt.subplots(nrows=3, figsize=(6,12), sharex=True, sharey=True)
    for (ax, embedding, title) in zip(axs, [embedding1, embedding2, embedding3], labels):
        hist = np.histogram2d(embedding[:,0], embedding[:,1], bins=(x_line, y_line))[0]
        hist = np.transpose(hist)
        hist[hist==0] = np.nan
        hist = np.log10(hist)
        hist[np.isnan(hist)] = np.nanmin(hist)
        ax.pcolormesh(x_line, y_line, hist, vmin=np.nanpercentile(hist, 0), vmax=np.nanpercentile(hist, 99.9))
        ax.set_aspect("equal")
        ax.set_title(title)
    fig.savefig(f"figs/hist-{outtag}.png")

def observation_filter(reducer, tracks_train):
    max_lim = 10000
    tracks2 = load_tracks("../data/02007999/event_l1/ixpe02007901_det1_evt1_v01.fits", max_lim=max_lim) # G0.13-0.11
    tracks3 = load_tracks("../data/sim.fits", max_lim=max_lim)
    discriminate(reducer, tracks_train, tracks2, tracks3, outtag="obs", labels=["Training set", "Data (G0.13-0.11)", "Simulation"])

def energy_filter(reducer, tracks_train):
    # This uses the moments energies
    l1_file = "../data/01002601/event_l1/ixpe01002601_det1_evt1_v02.fits"
    l2_file = "../data/01002601/event_l2/ixpe01002601_det1_evt2_v01.fits"
    max_lim = 10000

    tracks2 = load_tracks(l1_file, max_lim=max_lim, energy_filter=(2,3,l2_file))
    tracks3 = load_tracks(l1_file, max_lim=max_lim, energy_filter=(5,8,l2_file))
    discriminate(reducer, tracks_train, tracks2, tracks3, outtag="energy", labels=["Training set", "Data (2-3 keV)", "Data (5-8 keV)"])

def position_filter(reducer, tracks_train):
    l1_file = "../data/02008801/event_l1/ixpe02008801_det1_evt1_v01.fits"
    max_lim = 10000

    tracks2 = load_tracks(l1_file, max_lim=max_lim, position_filter=(305,300,10))
    tracks3 = load_tracks(l1_file, max_lim=max_lim, position_filter=(305,300,-10))
    discriminate(reducer, tracks_train, tracks2, tracks3, outtag="position", labels=["Training set", "Data (PS)", "Data (BG)"])