"""Generate background and truth data sets from data"""
import numpy as np
import sys
from astropy.io import fits
sys.path.append("../common")
from load import process_track

STATUS_MASK = [True,False,True,True,True,True,True,True,True,True,True,True,False,True,True,False]

def make_dataset(sources, name, ncut=None):
    """
    # Arguments
    * sources: list of
        - l1_filename
        - mom_filename
        - energy_range (or None)
        - pos_range (x, y, radius). If radius is negative, take the outside
    """

    tracks = []
    extra = []
    for (l1_filename, mom_filename, ecut, poscut) in sources:
        with fits.open(mom_filename) as hdul:
            energies = hdul[1].data["PI"] * 0.04 + 0.02
            xs = hdul[1].data["X"]
            ys = hdul[1].data["Y"]
        with fits.open(l1_filename) as hdul:
            l1_mask = ~np.any(hdul[1].data["STATUS2"] & STATUS_MASK, axis=-1)
            images = hdul[1].data["PIX_PHAS"][l1_mask]
            min_x = hdul[1].data["MIN_CHIPX"][l1_mask]
            min_y = hdul[1].data["MIN_CHIPY"][l1_mask]
            max_x = hdul[1].data["MAX_CHIPX"][l1_mask]
            max_y = hdul[1].data["MAX_CHIPY"][l1_mask]

        assert(np.sum(l1_mask) == len(xs))

        mask = np.ones_like(xs, bool)
        if ecut is not None:
            mask &= energies > ecut[0]
            mask &= energies < ecut[1]
        if poscut is not None:
            x_center, y_center, radius = poscut
            if radius > 0:
                mask &= (xs - x_center)**2 + (ys - y_center)**2 < radius**2
            else:
                mask &= (xs - x_center)**2 + (ys - y_center)**2 > radius**2

        if ncut is not None:
            mask &= np.cumsum(mask) < ncut+1 # Select the first events up to ncut

        for i in range(len(mask)):
            if not mask[i]: continue
            image = images[i].reshape(max_y[i]-min_y[i]+1, max_x[i]-min_x[i]+1)
            # if len(tracks) < 50:
                # print(len(tracks), min_x[i], max_x[i], min_y[i], max_y[i])
                # print(len(tracks), image.shape)
            tracks.append(process_track(image))
            extra.append(energies[i])

    print(f"Saved {len(tracks)} tracks in {name}")
    np.save(f"data/{name}.npy", tracks)
    np.save(f"data/{name}-extra.npy", extra)

if __name__ == "__main__":
    make_dataset(
        (
            (
                "../../data/01002601/event_l1/ixpe01002601_det1_evt1_v02.fits",
                "../../data/01002601/event_nn/ixpe01002601_det1_nn.fits",
                None, (301.39749, 303.70573, -65.854246)
            ),
        ),
        "background0",
        ncut=50_000
    )
    make_dataset(
        (
            (
                "../../data/01002601/event_l1/ixpe01002601_det1_evt1_v02.fits",
                "../../data/01002601/event_nn/ixpe01002601_det1_nn.fits",
                None, (301.39749, 303.70573, 10)
            ),
        ),
        "source0",
        ncut=50_000
    )

    # make_dataset(
    #     (
    #         (
    #             "../../data/02008801/event_l1/ixpe02008801_det1_evt1_v01.fits",
    #             "../../data/02008801/nobkgcorr/ixpe02008801_det1_nn.fits",
    #             None, (297.5, 299, -65.854246)
    #         ),
    #     ),
    #     "background0",
    #     ncut=10_000
    # )
    # make_dataset(
    #     (
    #         (
    #             "../../data/02008801/event_l1/ixpe02008801_det1_evt1_v01.fits",
    #             "../../data/02008801/nobkgcorr/ixpe02008801_det1_nn.fits",
    #             None, (297.5, 299, 8)
    #         ),
    #     ),
    #     "source0",
    #     ncut=10_000
    # )