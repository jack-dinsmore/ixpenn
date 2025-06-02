from astropy.io import fits
import sys
import shutil

# To address PI errors, make a new gain file with the non-GAIN columns removed and DETX_PX/DETY_PX changed to BARX_PX/BARY_PX

def manip(infile):
    outfile = f"{infile[:-5]}_manip.fits"
    shutil.copy(infile, outfile)
    with fits.open(outfile, mode="update") as hdul:
        new_hdul = [hdul[0]] + [hdu for hdu in hdul[1:] if hdu.name == 'GAIN'] 

        del hdul[:]
        for i, hdu in enumerate(new_hdul):
            if i > 0:
                print(i)
                hdu.columns.change_name('BARX_PX', 'DETX_PX')
                hdu.columns.change_name('BARY_PX', 'DETY_PX')
            hdul.append(hdu)

    print("Finished manipulating")
    print(f"In file: {infile}")
    print(f"Out file: {outfile}")

    with fits.open(outfile) as hdul:
        hdul.info()
        print(hdul[1].columns)


    with fits.open(infile) as hdul:
        hdul.info()
        print(hdul[1].columns)


if __name__ == "__main__":
    manip(sys.argv[1])
