from discriminate import *
from scipy.interpolate import RegularGridInterpolator
import shutil, os, sys, pickle
from load import STATUS_MASK

def make_interpolator():
    l1_file = "data/02008801/event_l1/ixpe02008801_det1_evt1_v01.fits"
    tracks_train = load_tracks(l1_file, max_lim=100000, position_filter=(305,300,50))
    tracks_phot = load_tracks(l1_file, max_lim=100000, position_filter=(305,300,10))
    tracks_bg = load_tracks(l1_file, max_lim=100000, position_filter=(305,300,-10))
    reducer = build_map(tracks_train)

    with open("reducer.pk", 'wb') as f:
        pickle.dump(reducer, f)

    embedding_phot = reducer.transform(tracks_phot.reshape(tracks_phot.shape[0], -1))
    embedding_bg = reducer.transform(tracks_bg.reshape(tracks_bg.shape[0], -1))

    x_line = np.arange(
        min(np.min(embedding_phot[:,0]), np.min(embedding_bg[:,0])),
        max(np.max(embedding_phot[:,0]), np.max(embedding_bg[:,0])),
        0.2)
    y_line = np.arange(
        min(np.min(embedding_phot[:,1]), np.min(embedding_bg[:,1])),
        max(np.max(embedding_phot[:,1]), np.max(embedding_bg[:,1])),
        0.2)
    x_centers = (x_line[1:] + x_line[:-1])/2
    y_centers = (y_line[1:] + y_line[:-1])/2

    hist_phot = np.histogram2d(embedding_phot[:,0], embedding_phot[:,1], (x_line, y_line))[0]
    hist_phot /= np.sum(hist_phot)

    hist_bg = np.histogram2d(embedding_bg[:,0], embedding_bg[:,1], (x_line, y_line))[0]
    hist_bg /= np.sum(hist_bg)

    prob_phot = hist_phot / (hist_phot + hist_bg)
    prob_phot[np.isnan(prob_phot)] = 0

    np.save("x_centers.npy", x_centers)
    np.save("y_centers.npy", y_centers)
    np.save("prob_phot.npy", prob_phot)

    print("Done generating the reducer")

def load_interpolator():
    x_centers = np.load("x_centers.npy")
    y_centers = np.load("y_centers.npy")
    prob_phot = np.load("prob_phot.npy")

    with open("reducer.pk", 'rb') as f:
        reducer = pickle.load(f)

    interpolator = RegularGridInterpolator((x_centers, y_centers), prob_phot, bounds_error=False)
    return interpolator, reducer

def plot_interpolator():
    x_centers = np.load("x_centers.npy")
    y_centers = np.load("y_centers.npy")
    x_edges = x_centers - (x_centers[1] - x_centers[0])/2
    y_edges = y_centers - (y_centers[1] - y_centers[0])/2
    x_edges = np.append(x_edges, x_edges[-1] + (x_centers[1] - x_centers[0]))
    y_edges = np.append(y_edges, y_edges[-1] + (y_centers[1] - y_centers[0]))
    prob_phot = np.load("prob_phot.npy")

    fig, ax = plt.subplots()
    c = ax.pcolormesh(x_edges, y_edges, np.transpose(prob_phot))
    fig.colorbar(c, label="Photon probability")
    fig.savefig("figs/interpolator.png")

def clean(l1file, l2file):
    interpolator, reducer = load_interpolator()
    outdir = '/'.join(l1file.split('/')[:-2] + ["event_clean"])
    outfile = f"{outdir}/{l1file.split('/')[-1][:16]}_evt3_v01.fits"

    if not os.path.exists(outdir):
        os.makedirs(outdir)
    shutil.copy(l2file, outfile)

    tracks = load_tracks(l1file)

    print("Start transforming")
    embedding = reducer.transform(tracks.reshape(tracks.shape[0], -1))
    print("Done transforming")
    probs = interpolator(embedding)

    with fits.open(outfile, mode="update") as hdul:
        row_mask = np.zeros(len(hdul[1].data)).astype(bool)
        if len(tracks) != len(hdul[1].data):
            raise Exception(f"The number of L1 events {len(tracks)} is not the same as the number of L2 events {len(hdul[1].data)}")
        initial_length = len(hdul[1].data)
        for row in range(len(hdul[1].data)):
            prob = probs[row]
            row_mask[row] = not np.isnan(prob) and 0.5 < prob
        hdul[1].data = hdul[1].data[row_mask]
        hdul.flush()
        print(f"Removed {np.sum(1-row_mask)}/{initial_length}")

if __name__ == "__main__":
    # make_interpolator()
    # plot_interpolator()

    exclude_l1 = "data/02007999/event_l1/ixpe02007901_det1_evt1_v01.fits"
    exclude_l2 = "data/02007999/my_event_l2/ixpe02007901_det1_l2.fits"
    # exclude_l1 = "data/02008801/event_l1/ixpe02008801_det1_evt1_v01.fits"
    # exclude_l2 = "data/02008801/my_event_l2/ixpe02008801_det1_l2.fits"
    # exclude_l1 = "data/01002601/event_l1/ixpe01002601_det1_evt1_v02.fits"
    # exclude_l2 = "data/01002601/my_event_l2/ixpe01002601_det1_l2.fits"
    clean(exclude_l1, exclude_l2)