module input_buffer #(
    parameter DEPTH=784
)(
    input wire clk,
    input wire we,
    input wire [9:0] addr,
    input wire signed [7:0] din,
    output reg signed [7:0] dout
);
reg signed [7:0] mem [0:DEPTH-1];
always @(posedge clk) begin
    if(we) mem[addr] <= din;
    dout <= mem[addr];
end
endmodule
