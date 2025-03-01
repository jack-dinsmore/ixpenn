import numpy as np
from astropy.io import fits
from scipy import ndimage

STATUS_MASK = [True,False,True,True,True,True,True,True,True,True,True,True,False,True,True,False]
REBIN = 3
WIDTH=12
HEIGHT=18

def rotate(track):
    # Rotate to put the track aligning upwards
    track_sum = np.sum(track)
    x_line = np.arange(track.shape[0]).astype(float)
    y_line = np.arange(track.shape[1]).astype(float)
    xs, ys = np.meshgrid(x_line, y_line, indexing="ij")
    mom_x = np.sum(xs * track) / track_sum
    mom_y = np.sum(ys * track) / track_sum
    mom_xy = np.sum(track * (xs - mom_x) * (ys - mom_y))
    mom_xx = np.sum(track * (xs - mom_x)**2)
    mom_yy = np.sum(track * (ys - mom_y)**2)
    angle_radians = 0.5 * np.arctan2(2 * mom_xy, (mom_xx - mom_yy))

    track = ndimage.rotate(track, -angle_radians * 180 / np.pi, reshape=False)
    return track

def process_track(track):
    track = track.astype(float) - np.nanpercentile(track, 25) # Remove background so that the image can be padded with zeros later
    track = np.maximum(track, 0)

    # Rebin
    new_track = np.zeros((track.shape[0]//REBIN, track.shape[1]//REBIN))
    for i in range(REBIN):
        for j in range(REBIN):
            rebinned = track[i::REBIN,:][:,j::REBIN]
            new_track += rebinned[:new_track.shape[0], :new_track.shape[1]]
    track = new_track

    # Rotate the track
    track = rotate(track)

    # Trim
    if track.shape[0] > HEIGHT:
        start_x = (track.shape[0]-HEIGHT)//2
        stop_x = (track.shape[0]+HEIGHT)//2
        track = track[start_x:stop_x, :]
    elif track.shape[0] < HEIGHT:
        initial_x = (HEIGHT-track.shape[0])//2
        odd = (HEIGHT - track.shape[0]) % 2
        track = np.vstack((np.zeros((initial_x, track.shape[1])), track, np.zeros((initial_x+odd, track.shape[1]))))
    if track.shape[1] > WIDTH:
        start_y = (track.shape[1]-WIDTH)//2
        stop_y = (track.shape[1]+WIDTH)//2
        track = track[:,start_y:stop_y]
    elif track.shape[1] < WIDTH:
        initial_y = (WIDTH - track.shape[1]) // 2
        odd = (WIDTH - track.shape[1]) % 2
        track = np.hstack((np.zeros((track.shape[0], initial_y)), track, np.zeros((track.shape[0], initial_y+odd))))
    return track


def load_tracks(datafile, max_lim=None, energy_filter=None, position_filter=None):
    """
    Loads tracks from a fits file
    # Arguments:
    * max_lim: the maximum number of tracks to load
    * energy_filter: the energy range to use
    * position_filter: the position range to use
    # Returns
    A list of images, all reshaped to the same size
    """
    tracks = []
    energies = None
    if energy_filter is not None:
        with fits.open(energy_filter[2]) as hdul:
            energies = hdul[1].data["PI"] * 0.04 + 0.02
    if position_filter is not None:
        with fits.open(datafile) as hdul:
            # print(hdul[1].columns)
            x = np.array(hdul[1].data["X"])
            y = np.array(hdul[1].data["Y"])

    with fits.open(datafile, memmap=True) as hdul:
        # Load the event
        data = hdul[1].data
        if "STATUS2" in data.columns.names:
            flagged = np.any(data["STATUS2"] & STATUS_MASK, axis=1)
        else:
            flagged = np.zeros(len(data["MIN_CHIPX"])).astype(bool)
        for event_index in range(len(data)):
            if flagged[event_index]: continue
            if max_lim is not None and len(tracks) >= max_lim: break
            min_x = data["MIN_CHIPX"][event_index]
            min_y = data["MIN_CHIPY"][event_index]
            max_x = data["MAX_CHIPX"][event_index]
            max_y = data["MAX_CHIPY"][event_index]
            track = data["PIX_PHAS"][event_index].reshape(max_y-min_y+1, max_x-min_x+1)
            if energy_filter is not None:
                energy = energies[event_index]
                if (energy < energy_filter[0] or energy > energy_filter[1]):
                    continue
            if position_filter is not None:
                dist2 = (x[event_index] - position_filter[0])**2 + (y[event_index] - position_filter[1])**2
                if position_filter[2] > 0:
                    if dist2 > position_filter[2]**2:
                        # Accept only events inside the radios
                        continue
                else:
                    if dist2 < position_filter[2]**2:
                        # Accept only events outside the radios
                        continue
            tracks.append(process_track(track))

    tracks = np.array(tracks)
    print("Tracks processed", tracks.shape)
    return tracks