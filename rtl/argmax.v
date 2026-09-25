module argmax(
    input wire signed [31:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,
    output reg [3:0] index
);
integer i;
reg signed [31:0] best;
always @* begin
    best=x0; index=0;
    if(x1>best) begin best=x1; index=1; end
    if(x2>best) begin best=x2; index=2; end
    if(x3>best) begin best=x3; index=3; end
    if(x4>best) begin best=x4; index=4; end
    if(x5>best) begin best=x5; index=5; end
    if(x6>best) begin best=x6; index=6; end
    if(x7>best) begin best=x7; index=7; end
    if(x8>best) begin best=x8; index=8; end
    if(x9>best) begin best=x9; index=9; end
end
endmodule
