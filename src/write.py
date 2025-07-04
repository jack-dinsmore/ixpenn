from astropy.io import fits
import sys, shutil, os
import numpy as np

in_file = sys.argv[1]
nn_file = sys.argv[2]
out_file = sys.argv[3]

# Files to cut the last event of
cut_end_file = [
    "/home/groups/rwr/ixpenn/data/02007999/recon/ixpe02007901_det2_evt1_v01_recon_gain_corr_map.fits"
]

print(in_file)
print(nn_file)
print(out_file)

#os.system(f"ftpaste {in_file}'[EVENTS][col -DETPHI2;]' {nn_file}'[1][col NN_PHI, DETPHI2==NN_PHI; NN_WEIGHT, W_NN==NN_WEIGHT; P_TAIL; FLAG]' {out_file} history=YES clobber=True")

with fits.open(nn_file) as hdul:
    table = hdul[1].data
    nn_phi = table["NN_PHI"]
    nn_weight = table["NN_WEIGHT"]
    xy_nn_abs = table["XY_NN_ABS"]
    abs_x = np.copy(xy_nn_abs[:,0].reshape(-1))
    abs_y = np.copy(xy_nn_abs[:,1].reshape(-1))
    nn_energy = table["NN_ENERGY"]
    p_tail = table["P_TAIL"]
    flag = table["FLAG"]

pi = np.round((nn_energy - 0.020) / 0.040).astype(int)
print([np.nanpercentile(pi, i) for i in range(0, 105, 10)])

unwrapped_flags = np.zeros((len(flag), 16), bool)
for i in range(16):
    unwrapped_flags[:,i] = (flag & (1 << i)) != 0

if in_file in cut_end_file:
    nn_phi = nn_phi[:-1]
    nn_weight = nn_weight[:-1]
    xy_nn_abs = xy_nn_abs[:-1]
    abs_x = abs_x[:-1]
    abs_y = abs_y[:-1]
    pi = pi[:-1]
    nn_energy = nn_energy[:-1]
    p_tail = p_tail[:-1]
    unwrapped_flags = unwrapped_flags[:-1,:]


shutil.copy(in_file, out_file)

with fits.open(out_file, mode="update") as hdul:
    columns = hdul[1].columns
    if "STATUS2" in hdul[1].columns.names:
        print(hdul[1].data["STATUS2"].shape, unwrapped_flags.shape)
        flags = hdul[1].data["STATUS2"] | unwrapped_flags
    else:
        flags = unwrapped_flags

    print("WARNING: Clamping the NN positions not to be too big")
    abs_x = np.clip(abs_x, np.min(hdul[1].data["ABSX"]), np.max(hdul[1].data["ABSX"]))
    abs_y = np.clip(abs_y, np.min(hdul[1].data["ABSY"]), np.max(hdul[1].data["ABSY"]))
    
    # Update old columns
    hdul[1].data["DETPHI2"] = nn_phi
    hdul[1].data["PI"] = pi; print("Writing energies")
    hdul[1].data["ABSX"] = abs_x
    hdul[1].data["ABSY"] = abs_y
    if "STATUS2" in hdul[1].columns.names:
        hdul[1].data["STATUS2"] = flags 

    # Add new column
    columns.add_col(fits.Column(array=p_tail, name="P_TAIL", format="1E"))
    columns.add_col(fits.Column(array=nn_weight, name="W_NN", format="1E"))

    header = hdul[1].header
    hdul[1] = fits.BinTableHDU.from_columns(columns, header)
    
    hdul.flush()

print(f"NN file: {nn_file}")
print(f"In file: {in_file}")
print(f"Out file: {out_file}")
