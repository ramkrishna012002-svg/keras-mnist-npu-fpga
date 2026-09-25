from pathlib import Path
import numpy as np
import keras

OUT = Path("artifacts")
OUT.mkdir(exist_ok=True)
model = keras.models.load_model(OUT / "mnist.keras")

for name in ("dense1", "dense2", "dense3"):
    layer = model.get_layer(name)
    w, b = layer.get_weights()
    np.save(OUT / f"{name}_weights.npy", w.astype(np.float32))
    np.save(OUT / f"{name}_bias.npy", b.astype(np.float32))
    print(name, "weights", w.shape, "bias", b.shape)
