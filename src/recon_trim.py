from astropy.io import fits
import sys

def strip(filename):
    with fits.open(filename, mode="update") as hdul:
        if "PIX_TRK" in hdul[1].data.columns.names:
            hdul[1].data.columns.del_col("PIX_TRK")
        else:
            print("Could not find PIX_TRK column")

        if "PIX_PHAS_EQ" in hdul[1].data.columns.names:
            hdul[1].data.columns.del_col("PIX_PHAS_EQ")
        else:
            print("Could not find PIX_PHAS_EQ column")

        hdul.flush()


for arg in sys.argv[1:]:
    strip(arg)
