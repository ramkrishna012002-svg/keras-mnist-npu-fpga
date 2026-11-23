// ReLU for a signed INT8 activation.
module relu_int8 (
    input wire signed [7:0] data_in,
    output wire signed [7:0] data_out
);
    assign data_out = data_in[7] ? 8'sd0 : data_in;
endmodule
