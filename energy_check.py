from astropy.io import fits
import matplotlib.pyplot as plt
import sys, os

obs_id = sys.argv[1]

dirname = f"data/{obs_id}/recon"
for f in os.listdir(dirname):
    if "gain_corr_map" not in f: continue
    if "det1" not in f: continue
    print(f)
    with fits.open(f"{dirname}/{f}") as hdul:
        pis = hdul[1].data["PI"]
        times = hdul[1].data["TIME"]
        fig, ax = plt.subplots()
        ax.scatter(times, pis)
        fig.savefig("energy_check.png")
        break
