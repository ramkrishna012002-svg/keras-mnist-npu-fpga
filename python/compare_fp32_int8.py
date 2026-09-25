from pathlib import Path
import json
import numpy as np
import keras

ART=Path("artifacts")
meta=json.loads((ART/"quantization.json").read_text())
model=keras.models.load_model(ART/"mnist.keras")
(_, _),(x,y)=keras.datasets.mnist.load_data()
x=x.reshape(-1,784).astype(np.float32)/255.0

def q(a,s): return np.clip(np.rint(a/s),-128,127).astype(np.int8)
xq=q(x,meta["input_scale"]); scale=meta["input_scale"]
for i,n in enumerate(("dense1","dense2","dense3")):
    info=meta["layers"][i]
    w=np.load(ART/f"{n}_w_int8.npy"); b=np.load(ART/f"{n}_b_int32.npy")
    z=xq.astype(np.int32)@w.astype(np.int32)+b.astype(np.int32)
    if i<2:
        z=np.maximum(z,0)
        ns=info["activation_scale"]
        xq=np.clip(np.rint(z*scale*info["weight_scale"]/ns),0,127).astype(np.int8)
        scale=ns
    else: qlog=z
p_int=np.argmax(qlog,1)
p_fp=np.argmax(model.predict(x,batch_size=256,verbose=0),1)
print("FP32 accuracy:",np.mean(p_fp==y))
print("INT8/INT32 accuracy:",np.mean(p_int==y))
print("FP32/INT8 agreement:",np.mean(p_fp==p_int))
