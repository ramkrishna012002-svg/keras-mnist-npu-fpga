from pathlib import Path
import keras
from model import build_model

OUT = Path("artifacts")
OUT.mkdir(exist_ok=True)

(x_train, y_train), (x_test, y_test) = keras.datasets.mnist.load_data()
x_train = x_train.reshape(-1, 784).astype("float32") / 255.0
x_test = x_test.reshape(-1, 784).astype("float32") / 255.0

model = build_model()
model.compile(
    optimizer=keras.optimizers.Adam(),
    loss=keras.losses.SparseCategoricalCrossentropy(from_logits=True),
    metrics=["accuracy"],
)
model.fit(x_train, y_train, epochs=10, batch_size=128, validation_split=0.1)
model.save(OUT / "mnist.keras")

loss, acc = model.evaluate(x_test, y_test, verbose=0)
print(f"test_loss={loss:.6f}")
print(f"test_accuracy={acc:.6f}")
