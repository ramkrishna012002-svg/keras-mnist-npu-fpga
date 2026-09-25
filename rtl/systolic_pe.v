module systolic_pe (
    input wire clk,
    input wire rst,
    input wire en,
    input wire signed [7:0] a_in,
    input wire signed [7:0] w_in,
    output reg signed [7:0] a_out,
    output reg signed [7:0] w_out,
    output reg signed [31:0] acc
);
    reg signed [7:0] a_reg;
    reg signed [7:0] w_reg;
    reg signed [15:0] product;

    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 0; w_reg <= 0; a_out <= 0; w_out <= 0; acc <= 0;
        end else if (en) begin
            a_reg <= a_in;
            w_reg <= w_in;
            a_out <= a_reg;
            w_out <= w_reg;
            product = a_reg * w_reg;
            acc <= acc + {{16{product[15]}}, product};
        end
    end
endmodule
