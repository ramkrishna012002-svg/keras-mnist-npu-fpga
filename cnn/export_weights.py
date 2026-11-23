from pathlib import Path
import numpy as np
import tensorflow as tf


def main():
    model_path = Path("artifacts/mnist_cnn.keras")
    if not model_path.exists():
        raise FileNotFoundError("Run: python cnn/train_mnist.py")

    out_dir = Path("artifacts/cnn_weights")
    out_dir.mkdir(parents=True, exist_ok=True)
    model = tf.keras.models.load_model(model_path)

    for layer in model.layers:
        params = layer.get_weights()
        if not params:
            continue
        np.save(out_dir / f"{layer.name}_weights.npy", params[0])
        np.save(out_dir / f"{layer.name}_bias.npy", params[1])
        print(
            f"{layer.name}: weights {params[0].shape}, "
            f"bias {params[1].shape}"
        )


if __name__ == "__main__":
    main()
