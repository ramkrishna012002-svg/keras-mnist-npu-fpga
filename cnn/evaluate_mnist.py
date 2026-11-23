from pathlib import Path
import tensorflow as tf


def main():
    model_path = Path("artifacts/mnist_cnn.keras")
    if not model_path.exists():
        raise FileNotFoundError("Run: python cnn/train_mnist.py")

    model = tf.keras.models.load_model(model_path)
    (_, _), (x_test, y_test) = tf.keras.datasets.mnist.load_data()
    x_test = x_test.astype("float32")[..., None] / 255.0

    loss, accuracy = model.evaluate(x_test, y_test, verbose=0)
    print(f"CNN test loss: {loss:.6f}")
    print(f"CNN test accuracy: {accuracy * 100:.2f}%")


if __name__ == "__main__":
    main()
