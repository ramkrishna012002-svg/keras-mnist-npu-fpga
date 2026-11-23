from pathlib import Path
import tensorflow as tf

from model import build_model


ARTIFACTS = Path("artifacts")
ARTIFACTS.mkdir(exist_ok=True)


def main():
    (x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()

    # Keep the channel dimension: 28 x 28 x 1.
    x_train = x_train.astype("float32")[..., None] / 255.0
    x_test = x_test.astype("float32")[..., None] / 255.0

    model = build_model()
    model.compile(
        optimizer=tf.keras.optimizers.Adam(),
        loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
        metrics=["accuracy"],
    )
    model.summary()
    model.fit(
        x_train,
        y_train,
        validation_split=0.1,
        epochs=8,
        batch_size=128,
        verbose=2,
    )
    test_loss, test_accuracy = model.evaluate(x_test, y_test, verbose=0)
    print(f"Test loss: {test_loss:.6f}")
    print(f"Test accuracy: {test_accuracy * 100:.2f}%")
    model.save(ARTIFACTS / "mnist_cnn.keras")


if __name__ == "__main__":
    main()
