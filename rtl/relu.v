module relu(
    input wire signed [31:0] in_value,
    output wire signed [31:0] out_value
);
assign out_value = in_value[31] ? 32'sd0 : in_value;
endmodule
