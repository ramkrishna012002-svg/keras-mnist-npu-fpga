from pathlib import Path
import json
import numpy as np
import keras

ART = Path("artifacts")
ART.mkdir(exist_ok=True)

model = keras.models.load_model(ART / "mnist.keras")
(x_train, _), _ = keras.datasets.mnist.load_data()
x_train = x_train.reshape(-1, 784).astype(np.float32) / 255.0

def qsym(x, scale):
    return np.clip(np.rint(x / scale), -128, 127).astype(np.int8)

def scale_for(x):
    m = float(np.max(np.abs(x)))
    return m / 127.0 if m else 1.0

# Input is exactly 0..127 after x/255 and scale=1/127.
input_scale = 1.0 / 127.0
metadata = {"input_scale": input_scale, "layers": []}

acts = x_train
for idx, name in enumerate(("dense1", "dense2", "dense3")):
    layer = model.get_layer(name)
    w, b = layer.get_weights()
    ws = scale_for(w)
    wq = qsym(w, ws)
    # Bias is represented in the accumulator's input*weight units.
    bq = np.rint(b / (input_scale * ws)).astype(np.int64)
    bq = np.clip(bq, -(2**31), 2**31-1).astype(np.int32)

    np.save(ART / f"{name}_w_int8.npy", wq)
    np.save(ART / f"{name}_b_int32.npy", bq)

    metadata["layers"].append({
        "name": name,
        "weight_scale": ws,
        "bias_scale": input_scale * ws,
        "weight_shape": list(w.shape),
        "bias_shape": list(b.shape),
    })

    # Calibrate the next activation using a representative training subset.
    y = acts @ w + b
    if idx < 2:
        y = np.maximum(y, 0.0)
        ascale = scale_for(y[:10000])
        metadata["layers"][-1]["activation_scale"] = ascale
        acts = np.clip(np.rint(y / ascale), 0, 127).astype(np.float32) * ascale
        input_scale = ascale

    print(name, "weight_scale=", ws)

(ART / "quantization.json").write_text(json.dumps(metadata, indent=2))
print("Wrote quantized weights, biases, and quantization.json")
