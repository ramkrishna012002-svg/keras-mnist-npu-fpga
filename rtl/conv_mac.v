// One multiply-accumulate element for a CNN convolution window.
// Feed one activation/weight pair per enabled clock.
// Clear acc with clear_acc before starting each output-channel sum.
module conv_mac (
    input wire clk,
    input wire rst,
    input wire clear_acc,
    input wire en,
    input wire signed [7:0] activation,
    input wire signed [7:0] weight,
    output reg signed [31:0] acc
);
    wire signed [15:0] product;
    assign product = activation * weight;

    always @(posedge clk) begin
        if (rst)
            acc <= 32'sd0;
        else if (clear_acc)
            acc <= 32'sd0;
        else if (en)
            acc <= acc + {{16{product[15]}}, product};
    end
endmodule
