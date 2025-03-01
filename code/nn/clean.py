import argparse, sys, os
from train import evaluate_model
sys.path.append("../common")
from load import load_tracks
from astropy.io import fits

def clean_background(l1file, infile, outfile):
    if not os.path.exists(l1file):
        raise Exception(f"Could not find the l1 file {l1file}")
    if not os.path.exists(infile):
        raise Exception(f"Could not find the input file {infile}")
    tracks = load_tracks(l1file)
    probabilities = evaluate_model(tracks)
    mask = probabilities < 0.5
    mask_file(infile, outfile, mask)

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
    parser = argparse.ArgumentParser(
                prog='fumigate',
                description='Removes background particles from IXPE datasets')
    parser.add_argument("l1")
    parser.add_argument("infile")
    parser.add_argument("outfile")

    args = parser.parse_args()

    clean_background(args.l1, args.infile, args.outfile)
