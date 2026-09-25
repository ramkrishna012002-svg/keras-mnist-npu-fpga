module mnist_npu_top(
    input wire clk,
    input wire rst,
    input wire start,
    input wire signed [7:0] a0_in,a1_in,a2_in,a3_in,
    input wire signed [7:0] w0_in,w1_in,w2_in,w3_in,
    output wire done,
    output wire [3:0] digit
);
reg running;
reg [10:0] cycle;
wire signed [31:0] y00,y01,y02,y03,y10,y11,y12,y13,y20,y21,y22,y23,y30,y31,y32,y33;

assign done = (running && cycle==11'd783);
assign digit = 4'd0;

systolic_array_4x4 sa(
    clk,rst,running,
    a0_in,a1_in,a2_in,a3_in,
    w0_in,w1_in,w2_in,w3_in,
    y00,y01,y02,y03,y10,y11,y12,y13,y20,y21,y22,y23,y30,y31,y32,y33
);

always @(posedge clk) begin
    if(rst) begin running<=0; cycle<=0; end
    else if(start) begin running<=1; cycle<=0; end
    else if(running) begin
        if(cycle==11'd783) running<=0;
        else cycle<=cycle+1'b1;
    end
end
endmodule
