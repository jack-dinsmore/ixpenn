import numpy as np
import matplotlib.pyplot as plt
import argparse, sys, os
from train import load_model
sys.path.append("../common")
from load import process_track, STATUS_MASK
from astropy.io import fits

plt.style.use("root")

def display_clean(infile, outfile):
    fig, axs = plt.subplots(ncols=3, figsize=(18,6), sharex=True, sharey=True)

    with fits.open(infile) as hdul:
        xs_in = hdul[1].data["X"] * 2.6 / 60
        ys_in = hdul[1].data["Y"] * 2.6 / 60
        energies_in = hdul[1].data["PI"] * 0.04 + 0.02
        mask = (energies_in > 2) & (energies_in < 8)
        xs_in = xs_in[mask]
        ys_in = ys_in[mask]
    with fits.open(outfile) as hdul:
        xs_out = hdul[1].data["X"] * 2.6 / 60
        ys_out = hdul[1].data["Y"] * 2.6 / 60
        energies_out = hdul[1].data["PI"] * 0.04 + 0.02
        mask = (energies_out > 2) & (energies_out < 8)
        xs_out = xs_out[mask]
        ys_out = ys_out[mask]
    xs_out -= np.median(xs_in)
    ys_out -= np.median(ys_in)
    xs_in -= np.median(xs_in)
    ys_in -= np.median(ys_in)

    bg_mask_annulus = (np.sqrt(xs_out**2 + ys_out**2) > 2) & (np.sqrt(xs_out**2 + ys_out**2) < 4)
    bg_rate = np.sum(bg_mask_annulus) / ((4**2 - 2**2) * np.pi)

    bg_mask_in = np.sqrt(xs_in**2 + ys_in**2) > 3
    bg_mask_out = np.sqrt(xs_out**2 + ys_out**2) > 3
    src_mask_in = np.sqrt(xs_in**2 + ys_in**2) < 0.5
    src_mask_out = np.sqrt(xs_out**2 + ys_out**2) < 0.5
    bg_ratio = 1 - np.sum(bg_mask_out) / np.sum(bg_mask_in) # Cut over expected quantity to be cut
    expected_src_bg_photons = bg_rate * (np.pi * 0.5**2)
    src_ratio = 1 - np.sum(src_mask_out) / (np.sum(src_mask_in) - expected_src_bg_photons)
    circle_x = np.cos(np.linspace(0, 2*np.pi, 300))
    circle_y = np.sin(np.linspace(0, 2*np.pi, 300))

    bins = np.linspace(-8,8,100)
    counts_in = np.histogram2d(xs_in, ys_in, (bins, bins))[0].astype(float)
    counts_out = np.histogram2d(xs_out, ys_out, (bins, bins))[0].astype(float)
    vmax = np.log(1+np.nanmax(counts_in))
    c = axs[0].pcolormesh(bins, bins, np.log(1+counts_in), vmax=vmax, vmin=0)
    c = axs[1].pcolormesh(bins, bins, np.log(1+counts_out), vmax=vmax, vmin=0)
    c = axs[2].pcolormesh(bins, bins, np.log(1+counts_in - counts_out), vmax=vmax, vmin=0)
    axs[2].plot(circle_x*3, circle_y*3, color='lime', lw=1)
    axs[2].plot(circle_x*0.5, circle_y*0.5, color='lime', lw=1)
    fig.suptitle(f"BG cut fraction {bg_ratio:.4f}, Src cut fraction {src_ratio:.4f}")
    fig.colorbar(c)

    axs[0].set_title("Uncleaned")
    axs[1].set_title("Cleaned")
    axs[2].set_title("Difference")

    for ax in axs:
        ax.set_xlim(-8,8)
        ax.set_ylim(-8,8)
        ax.set_aspect("equal")
    fig.savefig("figs/clean.png")

def clean_background(l1file, infile, outfile, mask=None):
    if not os.path.exists(l1file):
        raise Exception(f"Could not find the l1 file {l1file}")
    if not os.path.exists(infile):
        raise Exception(f"Could not find the input file {infile}")
    
    probabilities = []
    model = load_model()

    tracks = []
    with fits.open(l1file, memmap=True) as hdul:
        # Load the event
        for event_index in range(len(hdul[1].data)):
            if np.any(hdul[1].data["STATUS2"][event_index] & STATUS_MASK): continue
            min_x = hdul[1].data["MIN_CHIPX"][event_index]
            min_y = hdul[1].data["MIN_CHIPY"][event_index]
            max_x = hdul[1].data["MAX_CHIPX"][event_index]
            max_y = hdul[1].data["MAX_CHIPY"][event_index]
            track = hdul[1].data["PIX_PHAS"][event_index].reshape(max_y-min_y+1, max_x-min_x+1)
            tracks.append(process_track(track))

            if len(tracks) == 2048:
                # Compute track probabilities
                tracks = np.array(tracks)
                shape = tuple(np.concatenate([tracks.shape, [1]]))
                probs = model(tracks.reshape(shape)).numpy()
                probabilities = np.concatenate([probabilities, probs[:,0]])
                tracks = []


    tracks = np.array(tracks)
    shape = tuple(np.concatenate([tracks.shape, [1]]))
    probs = model(tracks.reshape(shape)).numpy()
    probabilities = np.concatenate([probabilities, probs[:,0]])

    if mask is None:
        write_weights(infile, outfile, probabilities)

    else:
        evt_mask = probabilities < mask
        mask_file(infile, outfile, evt_mask)

def mask_file(infile, outfile, mask):
    '''Mask the file by removing events
    # Arguments
        * infile: file name which will be masked
        * output file: file which will be written to. If the file already exists, it will be overwritten.
        * mask: boolean array created by `get_mask`.'''
    
    with fits.open(infile) as hdul:
        if len(hdul[1].data) != len(mask):
            raise Exception("The L1 file you provided does not have the same number of events as the file you are masking..")

        # Copy all the file HDUs
        hdul_copy = fits.HDUList([hdu.copy() for hdu in hdul])
        
        # Apply the mask
        hdul_copy[1] = fits.BinTableHDU(data=hdul[1].data[mask], header=hdul[1].header)

        # Save to a new file
        hdul_copy.writeto(outfile, overwrite=True)

def write_weights(infile, outfile, weights):
    '''Mask the file by removing events
    # Arguments
        * infile: file name which will be masked
        * output file: file which will be written to. If the file already exists, it will be overwritten.
        * mask: boolean array created by `get_mask`.'''
    
    with fits.open(infile) as hdul:
        if len(hdul[1].data) != len(weights):
            raise Exception("The L1 file you provided does not have the same number of events as the file you are masking..")

        # Copy all the file HDUs
        hdul_copy = fits.HDUList([hdu.copy() for hdu in hdul])

        bg_prob_col = fits.Column(name='BG_PROB', format='E', array=weights)
        new_cols = hdul[1].columns + bg_prob_col
        hdul_copy[1] = fits.BinTableHDU.from_columns(new_cols, header=hdul[1].header)

        # Save to a new file
        hdul_copy.writeto(outfile, overwrite=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
                prog='clean',
                description='Removes background particles from IXPE datasets')
    parser.add_argument("l1", help="Name of the input l1 file")
    parser.add_argument("infile", help="Name of the input l2 file")
    parser.add_argument("outfile", help="Name of the output file")
    parser.add_argument("--thresh", default=None, help="Threshold background probability to cut(0-1)")

    args = parser.parse_args()

    clean_background(args.l1, args.infile, args.outfile, args.thresh)
    # display_clean(args.infile, args.outfile)
