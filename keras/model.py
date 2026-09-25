import keras

def build_model():
    return keras.Sequential([
        keras.Input(shape=(784,), name="input"),
        keras.layers.Dense(128, activation="relu", name="dense1"),
        keras.layers.Dense(128, activation="relu", name="dense2"),
        keras.layers.Dense(10, name="dense3"),
    ], name="mnist_npu")
