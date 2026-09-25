from pathlib import Path
import keras

model = keras.models.load_model(Path("artifacts/mnist.keras"))
(_, _), (x_test, y_test) = keras.datasets.mnist.load_data()
x_test = x_test.reshape(-1, 784).astype("float32") / 255.0
loss, acc = model.evaluate(x_test, y_test, verbose=0)
print(f"test_loss={loss:.6f}")
print(f"test_accuracy={acc:.6f}")
