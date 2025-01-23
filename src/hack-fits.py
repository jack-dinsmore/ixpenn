from shutil import copyfile
from tempfile import NamedTemporaryFile
from astropy.io import fits
import os, sys

IGNORE = [
        "ixpe02001060_det3",
        "ixpe02006030_det1"
]

def edit(filename, CHUNK_SIZE=4096):
    found = False
    with open(filename, "rb") as source:
        destination = NamedTemporaryFile(mode="wb")
        while True:
            data = source.read(CHUNK_SIZE)
            if not data:
                break
            if not found:
                index = data.find(b"PCOUNT")
                if index >= 0:
                    int_start = index + 20
                    while data[int_start] == ord(' '):
                        int_start += 1
                    if not data[int_start] == ord('0'):
                        int_end = data.find(b' ', int_start)
                        print(data[int_start:int_end])
                        n_spaces = int_end - int_start - 1
                        data = data[:int_start] + b' ' * n_spaces + b'0' + data[int_end:]
                    else:
                        print("Already set to zero")
                        destination.flush()
                        destination.close()
                        return
                    found = True
            destination.file.write(data)
    destination.flush()
    print("Finished")

    if found:
        copyfile(destination.name, filename)
    else:
        if CHUNK_SIZE > 1e5:
            print("Failed for the last time")
        else:
            edit(filename, int(CHUNK_SIZE*1.61803))
            print("Failed. Falling through")

    destination.close()

    # Open and close
    with fits.open(filename, mode="update", memmap=False) as hdul:
        print("Recently written to zero:", hdul[1].header["PCOUNT"])
        print(hdul[1].size)

if __name__ == "__main__":
    if len(sys.argv) == 1:
        for super_file in os.listdir("crab"):
            tag = f"crab/{super_file}/recon"
            if not os.path.isdir(tag): continue
            for f in os.listdir(tag):
                if not f.endswith("recon.fits"): continue
                ignore = False
                for i_f in IGNORE:
                    if i_f in f:
                        ignore = True
                        break
    
                if ignore:
                    print("Ignored", f)
                    continue
                fullname = f"{tag}/{f}"
                print(fullname)
                edit(fullname)
    else:
        edit(sys.argv[1])
