from pathlib import Path
import json
import numpy as np
import keras

ART = Path("artifacts")
meta = json.loads((ART / "quantization.json").read_text())
model = keras.models.load_model(ART / "mnist.keras")

(_, _), (x_test, y_test) = keras.datasets.mnist.load_data()
x_test = x_test.reshape(-1, 784).astype(np.float32) / 255.0

def q(x, scale):
    return np.clip(np.rint(x / scale), -128, 127).astype(np.int8)

def layer_int(xq, wq, bq):
    return xq.astype(np.int32) @ wq.astype(np.int32) + bq.astype(np.int32)

# Hardware-reference integer inference. Each hidden layer is requantized to INT8.
xq = q(x_test, meta["input_scale"])
current_scale = meta["input_scale"]

for i, name in enumerate(("dense1", "dense2", "dense3")):
    info = meta["layers"][i]
    wq = np.load(ART / f"{name}_w_int8.npy")
    bq = np.load(ART / f"{name}_b_int32.npy")
    acc = layer_int(xq, wq, bq)
    if i < 2:
        acc = np.maximum(acc, 0)
        out_scale = info["activation_scale"]
        xq = np.clip(np.rint(acc * current_scale * info["weight_scale"] / out_scale), 0, 127).astype(np.int8)
        current_scale = out_scale
    else:
        logits = acc

pred_int = np.argmax(logits, axis=1)
acc_int = np.mean(pred_int == y_test)

fp_logits = model.predict(x_test, batch_size=256, verbose=0)
pred_fp = np.argmax(fp_logits, axis=1)
acc_fp = np.mean(pred_fp == y_test)
agreement = np.mean(pred_int == pred_fp)

print(f"FP32 accuracy : {acc_fp:.6f}")
print(f"INT8/INT32 acc: {acc_int:.6f}")
print(f"prediction agreement: {agreement:.6f}")
print("mismatches:", int(np.sum(pred_int != pred_fp)))
