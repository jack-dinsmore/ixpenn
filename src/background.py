# Use DiMarco's method to remove background
# https://iopscience.iop.org/article/10.3847/1538-3881/acba0f/pdf

import numpy as np
import sys, os
from astropy.io import fits

STATUS2_MASK = np.array([c == '0' for c in "0x0000000000000x"])

def get_mask(l1_filename, pk_map_file, recon_file=None):
    """Returns an np array which contains the mask of background events.

    Please provide a level 1 file (with the data necessary to execute DiMarco's method)
    and a file whih contains either PIs or MOM energies. E.g. any file after the pkmap command,
    or the NN file.
    """
    if recon_file is None:
        recon_file = l1_filename
    with fits.open(l1_filename) as hdul:
        mask = np.ones(len(hdul[1].data), bool)
        if "STATUS2" in hdul[1].columns.names:
            mask &= ~np.any(hdul[1].data["STATUS2"] & STATUS2_MASK, axis=1)
        full_image = hdul[1].data["PIX_PHAS"][mask]

    with fits.open(recon_file) as hdul:
        pha = hdul[1].data["PHA"]
        n_pixels = hdul[1].data["NUM_PIX"]
        border_pixels = hdul[1].data["TRK_BORD"]

    total_counts = []
    for image in full_image:
        total_counts.append(np.sum(image))
    total_counts = np.array(total_counts)

    with fits.open(pk_map_file) as hdul:
        # Will pull energy from PI if it's there, otherwise the energy column if it's there
        if "PI" in hdul[1].columns.names:
            energy = hdul[1].data["pi"] * 0.04 + 0.02
        else:
            energy = hdul[1].data["MOM_ENERGY"]
        # Update the column names to the ones in the PKMAP file if they're present
        if "NUM_PIX" in hdul[1].columns.names:
            n_pixels = hdul[1].data["NUM_PIX"]
        if "PHA" in hdul[1].columns.names:
            pha = hdul[1].data["PHA"]
        if "TRK_BORD" in hdul[1].columns.names:
            border_pixels = hdul[1].data["TRK_BORD"]
        energy_fraction = pha / total_counts

    mask = np.ones_like(energy, bool)
    mask &= energy > 2
    mask &= energy < 8
    mask &= n_pixels < 115 + 195 * (energy / 8)**2
    mask &= 0.88 * (1 -  np.exp(-(energy + 0.25) / 1.1)) + 0.004 * energy + 0.01 < energy_fraction
    mask &= energy_fraction < 1
    mask &= border_pixels < 2

    return mask

def mask_file(infile, outfile, mask):
    '''Mask the 
    # Arguments
        * infile: file name which will be masked
        * output file: file which will be written to. If the file already exists, it will be overwritten.
        * mask: boolean array created by `get_mask`.'''
    
    with fits.open(infile) as hdul:
        if len(hdul[1].data) != len(mask):
            raise Exception("The L1 file you provided does not have the same number of events as the file you are masking. Please provide an L1 file later in the pipeline.")

        # Copy all the file HDUs
        hdul_copy = fits.HDUList([hdu.copy() for hdu in hdul])
        
        # Apply the mask
        hdul_copy[1] = fits.BinTableHDU(data=hdul[1].data[mask], header=hdul[1].header)

        # Save to a new file
        hdul_copy.writeto(outfile, overwrite=True)
        
if __name__ == "__main__":
    l1_filename = sys.argv[1]
    pk_map_file = sys.argv[2]
    infile = sys.argv[3]
    outfile = sys.argv[4]

    print("Level 1 file\t", l1_filename)
    print("PK map file\t", pk_map_file)
    print("Input file\t", infile)
    print("Output file\t", outfile)

    mask = get_mask(l1_filename, pk_map_file)
    mask_file(infile, outfile, mask)

    # Print some statistics
    print(f"Remaining fraction: {np.mean(mask)*100:.1f}% (Target ~20%)")
