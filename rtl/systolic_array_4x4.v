module systolic_array_4x4 (
    input wire clk,
    input wire rst,
    input wire en,
    input wire signed [7:0] a0_in, a1_in, a2_in, a3_in,
    input wire signed [7:0] w0_in, w1_in, w2_in, w3_in,
    output wire signed [31:0] y00,y01,y02,y03,
    output wire signed [31:0] y10,y11,y12,y13,
    output wire signed [31:0] y20,y21,y22,y23,
    output wire signed [31:0] y30,y31,y32,y33
);
    wire signed [7:0] a01,a02,a03,a11,a12,a13,a21,a22,a23,a31,a32,a33;
    wire signed [7:0] w10,w20,w30,w11,w21,w31,w12,w22,w32,w13,w23,w33;

    systolic_pe p00(clk,rst,en,a0_in,w0_in,a01,w10,y00);
    systolic_pe p01(clk,rst,en,a01,w1_in,a02,w11,y01);
    systolic_pe p02(clk,rst,en,a02,w2_in,a03,w12,y02);
    systolic_pe p03(clk,rst,en,a03,w3_in,,w13,y03);

    systolic_pe p10(clk,rst,en,a1_in,w10,a11,w20,y10);
    systolic_pe p11(clk,rst,en,a11,w11,a12,w21,y11);
    systolic_pe p12(clk,rst,en,a12,w12,a13,w22,y12);
    systolic_pe p13(clk,rst,en,a13,w13,,w23,y13);

    systolic_pe p20(clk,rst,en,a2_in,w20,a21,w30,y20);
    systolic_pe p21(clk,rst,en,a21,w21,a22,w31,y21);
    systolic_pe p22(clk,rst,en,a22,w22,a23,w32,y22);
    systolic_pe p23(clk,rst,en,a23,w23,,w33,y23);

    systolic_pe p30(clk,rst,en,a3_in,w30,a31,,y30);
    systolic_pe p31(clk,rst,en,a31,w31,a32,,y31);
    systolic_pe p32(clk,rst,en,a32,w32,a33,,y32);
    systolic_pe p33(clk,rst,en,a33,w33,,,y33);
endmodule
