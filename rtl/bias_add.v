module bias_add(
    input wire signed [31:0] value_in,
    input wire signed [31:0] bias,
    output wire signed [31:0] value_out
);
assign value_out = value_in + bias;
endmodule
