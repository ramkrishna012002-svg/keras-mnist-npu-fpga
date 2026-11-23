// Combinational max of the four values in one 2x2 pooling window.
// The caller supplies the four signed INT8 values from the feature map.
module maxpool2x2 (
    input wire signed [7:0] p00,
    input wire signed [7:0] p01,
    input wire signed [7:0] p10,
    input wire signed [7:0] p11,
    output reg signed [7:0] pooled
);
    reg signed [7:0] max_a;
    reg signed [7:0] max_b;

    always @* begin
        max_a = (p00 >= p01) ? p00 : p01;
        max_b = (p10 >= p11) ? p10 : p11;
        pooled = (max_a >= max_b) ? max_a : max_b;
    end
endmodule
