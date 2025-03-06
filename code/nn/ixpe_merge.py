import numpy as np
from astropy.io import fits
import sys

def merge(filenames):
    in_filenames = filenames[:-1]
    out_filename = filenames[-1]

    total_length = 0
    columns = None
    header = None
    for in_filename in in_filenames:
        with fits.open(in_filename) as hdul_in:
            total_length += len(hdul_in[1].data)
            columns = hdul_in[1].columns
            header = hdul_in[1].header

    hdu = fits.BinTableHDU.from_columns(columns, header=header, nrows=total_length)

    start = 0
    for du_index in range(3):
        with fits.open(in_filenames[du_index]) as hdul_in:
            end = start + len(hdul_in[1].data)
            for colname in hdul_in[1].columns.names:
                hdu.data[colname][start:end] = hdul_in[1].data[colname]
            start = end

    hdul = fits.HDUList([fits.PrimaryHDU(), hdu])
    hdul.writeto(out_filename, overwrite=True)

if __name__ == "__main__":
    merge(sys.argv[1:])
