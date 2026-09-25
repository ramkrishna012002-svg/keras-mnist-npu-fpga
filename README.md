# Keras MNIST NPU FPGA

A complete, beginner-friendly Keras-to-FPGA MNIST inference reference:
FP32 training -> INT8/INT32 quantization -> integer golden model -> 4x4
systolic RTL -> Verilog testbench -> Xilinx Vivado.

## Network
784 -> 128 ReLU -> 128 ReLU -> 10 logits.

The 28x28 image is flattened row-by-row into 784 values. Each hidden neuron
computes 784 multiply-accumulate operations plus a bias. There are 128 hidden
neurons, so the first hidden layer produces 128 values.

## Numeric convention
* Input: normalized FP32 [0,1], quantized to signed INT8 with scale 1/127.
* Weights: symmetric signed INT8, one scale per layer.
* INT8 x INT8 product: signed INT16.
* Accumulator: signed INT32.
* Bias: INT32 in accumulator units.
* Hidden activations: calibrated symmetric INT8.
* Final layer: INT32 logits; argmax does not need softmax.

The quantizer writes scales and integer tensors to `artifacts/`. It does not
invent trained weights; run the training/export scripts first.

## Python
```bash
pip install -r requirements.txt
python keras/train_mnist.py
python keras/evaluate_mnist.py
python keras/export_weights.py
python python/quantize_mnist.py
python python/golden_model.py
```

## Vivado
Vivado 2023.2 is the reference version and the target part is
`xc7vx485tffg1157-1`.

Run `vivado/create_project.tcl` in Vivado Tcl. All RTL is Verilog-2001
(`.v` only), with `mnist_npu_top` as synthesis top and
`mnist_npu_tb` as simulation top.

## 4x4 systolic core
The reusable core has 16 PEs. A values move left-to-right, weights move
top-to-bottom, and every PE accumulates an INT8xINT8 product into INT32.
The full 784-wide network is scheduled over many cycles; the RTL includes the
arithmetic core and a correctness-first top-level control reference.

See docs/ARCHITECTURE.md for the mapping and cycle model.
