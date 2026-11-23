import tensorflow as tf


def build_model():
    """Compact CNN: 28x28x1 -> Conv/Pool -> Conv/Pool -> Dense(10)."""
    return tf.keras.Sequential(
        [
            tf.keras.Input(shape=(28, 28, 1), name="image"),
            tf.keras.layers.Conv2D(
                8, kernel_size=3, padding="valid", activation="relu", name="conv1"
            ),
            tf.keras.layers.MaxPooling2D(pool_size=2, name="pool1"),
            tf.keras.layers.Conv2D(
                16, kernel_size=3, padding="valid", activation="relu", name="conv2"
            ),
            tf.keras.layers.MaxPooling2D(pool_size=2, name="pool2"),
            tf.keras.layers.Flatten(name="flatten"),
            tf.keras.layers.Dense(10, name="logits"),
        ],
        name="mnist_cnn_npu",
    )
