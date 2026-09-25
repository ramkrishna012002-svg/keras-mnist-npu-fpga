module systolic_array_4x4 (
    input wire clk, input wire rst, input wire en,
    input wire signed [7:0] a0_in, a1_in, a2_in, a3_in,
    input wire signed [7:0] w0_in, w1_in, w2_in, w3_in,
    output wire signed [31:0] y00,y01,y02,y03,
    output wire signed [31:0] y10,y11,y12,y13,
    output wire signed [31:0] y20,y21,y22,y23,
    output wire signed [31:0] y30,y31,y32,y33
);
    wire signed [7:0] a01,a02,a03,a11,a12,a13,a21,a22,a23,a31,a32,a33;
    wire signed [7:0] w10,w20,w30,w11,w21,w31,w12,w22,w32,w13,w23,w33;
    wire signed [7:0] unused_a03, unused_a13, unused_a23, unused_a33;
    wire signed [7:0] unused_w30, unused_w31, unused_w32, unused_w33;

    systolic_pe p00(.clk(clk),.rst(rst),.en(en),.a_in(a0_in),.w_in(w0_in),.a_out(a01),.w_out(w10),.acc(y00));
    systolic_pe p01(.clk(clk),.rst(rst),.en(en),.a_in(a01),.w_in(w1_in),.a_out(a02),.w_out(w11),.acc(y01));
    systolic_pe p02(.clk(clk),.rst(rst),.en(en),.a_in(a02),.w_in(w2_in),.a_out(a03),.w_out(w12),.acc(y02));
    systolic_pe p03(.clk(clk),.rst(rst),.en(en),.a_in(a03),.w_in(w3_in),.a_out(unused_a03),.w_out(w13),.acc(y03));

    systolic_pe p10(.clk(clk),.rst(rst),.en(en),.a_in(a1_in),.w_in(w10),.a_out(a11),.w_out(w20),.acc(y10));
    systolic_pe p11(.clk(clk),.rst(rst),.en(en),.a_in(a11),.w_in(w11),.a_out(a12),.w_out(w21),.acc(y11));
    systolic_pe p12(.clk(clk),.rst(rst),.en(en),.a_in(a12),.w_in(w12),.a_out(a13),.w_out(w22),.acc(y12));
    systolic_pe p13(.clk(clk),.rst(rst),.en(en),.a_in(a13),.w_in(w13),.a_out(unused_a13),.w_out(w23),.acc(y13));

    systolic_pe p20(.clk(clk),.rst(rst),.en(en),.a_in(a2_in),.w_in(w20),.a_out(a21),.w_out(w30),.acc(y20));
    systolic_pe p21(.clk(clk),.rst(rst),.en(en),.a_in(a21),.w_in(w21),.a_out(a22),.w_out(w31),.acc(y21));
    systolic_pe p22(.clk(clk),.rst(rst),.en(en),.a_in(a22),.w_in(w22),.a_out(a23),.w_out(w32),.acc(y22));
    systolic_pe p23(.clk(clk),.rst(rst),.en(en),.a_in(a23),.w_in(w23),.a_out(unused_a23),.w_out(w33),.acc(y23));

    systolic_pe p30(.clk(clk),.rst(rst),.en(en),.a_in(a3_in),.w_in(w30),.a_out(a31),.w_out(unused_w30),.acc(y30));
    systolic_pe p31(.clk(clk),.rst(rst),.en(en),.a_in(a31),.w_in(w31),.a_out(a32),.w_out(unused_w31),.acc(y31));
    systolic_pe p32(.clk(clk),.rst(rst),.en(en),.a_in(a32),.w_in(w32),.a_out(a33),.w_out(unused_w32),.acc(y32));
    systolic_pe p33(.clk(clk),.rst(rst),.en(en),.a_in(a33),.w_in(w33),.a_out(unused_a33),.w_out(unused_w33),.acc(y33));
endmodule
