import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras import layers, models
import pickle, os

plt.style.use("root")
VALIDATION_FRACTION = 0.2
DATA_DIR = f"{'/'.join(__file__.split("/")[:-1])}/data"

def get_image_shape():
    src = np.load("data/source0.npy")
    return (src.shape[1], src.shape[2], 1)

def load_model(index=None, return_index=False):
    """Get the tensorflow model. If index is not passed, the most recent will be returned"""
    if index is None:
        max_index = 0
        for f in os.listdir(DATA_DIR):
            if f.startswith("model"):
                period = f.find('.')
                index = int(f[5:period])
                max_index = max(max_index, index)
        index = max_index

    if return_index:
        return tf.keras.models.load_model(f"{DATA_DIR}/model{index}.keras"), index
    else:
        return tf.keras.models.load_model(f"{DATA_DIR}/model{index}.keras")

def get_datasets(index):
    if not os.path.exists(f"data/background{index}.npy"):
        if not os.path.exists(f"data/background{index-1}.npy"):
            raise Exception(f"You cannot build data with index {index} when index {index-1} does not exist.")
        
        # Make a data set based on the most recent model
        bg = np.load(f"data/background{index-1}.npy")
        src = np.load(f"data/source{index-1}.npy")

        probs = evaluate_model(bg)
        bg_mask = probs > 0.8
        src_mask = np.ones(len(src), bool)
        src_mask &= np.cumsum(src_mask) < np.sum(bg_mask) + 1 # Restrict such that the two have the same number

        print(f"Cutting {(1-np.mean(bg_mask))*100:.1f}% of the background as source")

        np.save(f"data/background{index}.npy", bg[bg_mask])
        np.save(f"data/source{index}.npy", src[src_mask])
        np.save(f"data/background{index}-extra.npy", np.load(f"data/background{index-1}-extra.npy")[bg_mask])
        np.save(f"data/source{index}-extra.npy", np.load(f"data/source{index-1}-extra.npy")[src_mask])

    bg = np.load(f"data/background{index}.npy")
    src = np.load(f"data/source{index}.npy")

    validation_index = int(len(bg) * VALIDATION_FRACTION)
    n_train = len(bg) - validation_index

    test_labels = np.concatenate([[1]*validation_index, [0]*validation_index])
    train_labels = np.concatenate([[1]*n_train, [0]*n_train])
    train_images = np.concatenate([bg[validation_index:], src[validation_index:]])
    test_images = np.concatenate([bg[:validation_index], src[:validation_index]])

    # Normalize
    return (train_images, train_labels), (test_images, test_labels)

def train_model(index=None):
    max_index = -1
    for f in os.listdir(DATA_DIR):
        if f.startswith("model"):
            period = f.find('.')
            index = int(f[5:period])
            max_index = max(max_index, index)
    index = max_index + 1

    image_shape = get_image_shape()
    model = models.Sequential()
    model.add(layers.Input(image_shape))
    model.add(layers.Conv2D(16, (3, 3), activation='relu', padding="same"))
    model.add(layers.MaxPooling2D((2, 2)))
    model.add(layers.Conv2D(32, (3, 3), activation='relu', padding="same"))
    model.add(layers.MaxPooling2D((2, 2)))
    model.add(layers.Conv2D(64, (3, 3), activation='relu', padding="same"))
    model.add(layers.MaxPooling2D((2, 2)))
    model.add(layers.Conv2D(128, (3, 3), activation='relu', padding="same"))
    model.add(layers.Flatten())
    model.add(layers.Dense(64, activation='relu'))
    model.add(layers.Dense(1, activation='sigmoid'))

    model.summary()

    model.compile(optimizer='adam',
                loss="binary_crossentropy",
                metrics=['accuracy'])

    (train_images, train_labels), (test_images, test_labels) = get_datasets(index)
    print(f"Training set: {len(train_images)}")
    print(f"Validation set: {len(test_images)}")
    history = model.fit(train_images, train_labels, epochs=8, 
                        validation_data=(test_images, test_labels))
    with open(f"{DATA_DIR}/history{index}.pk", 'wb') as f:
        pickle.dump(history.history, f)

    model.save(f"{DATA_DIR}/model{index}.keras")

def plot_model(model_index=None):
    model, model_index = load_model(model_index, return_index=True)
    with open(f"{DATA_DIR}/history{model_index}.pk", 'rb') as f:
        history = pickle.load(f)
    (train_images, train_labels), (test_images, test_labels) = get_datasets(model_index)

    fig, ax = plt.subplots()
    ax.plot(history['accuracy'], label='accuracy')
    ax.plot(history['val_accuracy'], label = 'val_accuracy')
    ax.set_xlabel('Epoch')
    ax.set_ylabel('Accuracy')
    ax.set_ylim([0.5, 1])
    ax.legend(loc='lower right')

    test_loss, test_accuracy = model.evaluate(test_images,  test_labels, verbose=2)
    fig.suptitle(f"Accuracy {test_accuracy*100:.1f}%")

    fig.savefig("figs/accuracy.png")

def evaluate_model(tracks, model_index=None):
    model = load_model(model_index)
    shape = tuple(np.concatenate([tracks.shape, [1]]))
    reshaped_tracks = tracks.reshape(shape) # Make monochromatic
    
    probabilities = model(reshaped_tracks).numpy()
    return probabilities[:,0]

def test_evaluate(model_index=None):
    bg_tracks = np.load(f"data/background0.npy")
    bg_probs = evaluate_model(bg_tracks)
    src_tracks = np.load(f"data/source0.npy")
    src_probs = evaluate_model(src_tracks)
    print(f"Background track prob {np.mean(bg_probs)}")
    print(f"Source track prob {np.mean(src_probs)}")

def assess_error(index):
    e_bin_edges = np.linspace(2, 8, 51)
    prob_bin_edges = np.linspace(0, 1, 50)
    bg_tracks = np.load(f"data/background{index}.npy")
    bg_energy = np.load(f"data/background{index}-extra.npy")
    bg_prob = evaluate_model(bg_tracks, index)

    src_tracks = np.load(f"data/source{index}.npy")
    src_energy = np.load(f"data/source{index}-extra.npy")
    src_prob = evaluate_model(src_tracks, index)

    fig, (ax_src, ax_bg) = plt.subplots(ncols=2, sharex=True, sharey=True)
    src_counts = np.histogram2d(src_energy, src_prob, bins=(e_bin_edges, prob_bin_edges))[0].astype(float)
    bg_counts = np.histogram2d(bg_energy, bg_prob, bins=(e_bin_edges, prob_bin_edges))[0].astype(float)

    # Take out spectrum
    src_counts = np.einsum("ij,i->ij", src_counts, 1/np.sum(src_counts, axis=1))
    bg_counts = np.einsum("ij,i->ij", bg_counts, 1/np.sum(bg_counts, axis=1))
    ax_src.pcolormesh(e_bin_edges, prob_bin_edges, np.transpose(src_counts), vmin=0)
    ax_bg.pcolormesh(e_bin_edges, prob_bin_edges, np.transpose(bg_counts), vmin=0)

    # Plot
    for ax in fig.axes:
        ax.set_xlim(e_bin_edges[0], e_bin_edges[-1])
        ax.set_ylim(0, 1)
    ax_src.set_title("Source")
    ax_bg.set_title("Source")
    ax_src.set_xlabel("Energy [keV]")
    ax_src.set_ylabel("BG probability")
    fig.savefig(f"figs/assess{index}.png")


if __name__ == "__main__":
    # train_model(0)
    # plot_model(0)
    # assess_error(0)

    # train_model(1)
    # plot_model(1)
    # assess_error(1)

    test_evaluate()