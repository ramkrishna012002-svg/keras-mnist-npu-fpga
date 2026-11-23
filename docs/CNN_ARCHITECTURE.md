# CNN MNIST NPU

## Network

Input is one normalized grayscale image with shape 28 x 28 x 1.

| Stage | Operation | Output shape |
|---|---|---:|
| Input | grayscale image | 28 x 28 x 1 |
| Conv1 | 8 filters, 3 x 3, valid, ReLU | 26 x 26 x 8 |
| Pool1 | 2 x 2 max pool, stride 2 | 13 x 13 x 8 |
| Conv2 | 16 filters, 3 x 3, valid, ReLU | 11 x 11 x 16 |
| Pool2 | 2 x 2 max pool, stride 2 | 5 x 5 x 16 |
| Flatten | reshape feature map | 400 |
| Classifier | Dense 10 logits | 10 |
| Output | argmax | digit 0 to 9 |

The dense classifier has 4,010 parameters (400 x 10 weights plus 10 biases).
Conv1 has 80 parameters (3 x 3 x 1 x 8 weights plus 8 biases).
Conv2 has 1,168 parameters (3 x 3 x 8 x 16 weights plus 16 biases).
Total trainable parameters: 5,258.

## Integer hardware convention

The intended FPGA datapath uses signed INT8 activations and weights, signed INT16 products, and signed INT32 accumulation. Bias is added in the accumulator's quantized scale. ReLU is applied before activation requantization. The final ten logits are compared by argmax; softmax is unnecessary when only the winning class is required.

Quantization scales must be exported from the trained model and used consistently by the Python integer reference and RTL. Do not assume that every layer shares one scale.

## RTL building blocks added

- `conv_mac.v`: one signed INT8 multiply-accumulate element.
- `relu_int8.v`: signed INT8 ReLU.
- `maxpool2x2.v`: combinational 2 x 2 maximum.

## Implementation stages

1. Train and evaluate the Keras CNN.
2. Export trained convolution and dense weights.
3. Build a quantized Python reference and generate memory initialization files.
4. Implement line buffers and a sliding 3 x 3 window generator.
5. Connect convolution MAC lanes, bias, ReLU, and activation requantization.
6. Add pooling, feature-map storage, and the final dense classifier.
7. Compare RTL outputs against the integer Python reference on fixed test images.

The RTL files currently added are arithmetic building blocks, not yet a complete end-to-end CNN accelerator. The line buffers, controller, trained-weight memories, requantization path, and full testbench still need to be implemented and verified.
