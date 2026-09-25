module mnist_npu_tb;
reg clk=0, rst=1, start=0;
reg signed [7:0] a0,a1,a2,a3,w0,w1,w2,w3;
wire done; wire [3:0] digit;

always #5 clk=~clk;

mnist_npu_top dut(
 .clk(clk),.rst(rst),.start(start),
 .a0_in(a0),.a1_in(a1),.a2_in(a2),.a3_in(a3),
 .w0_in(w0),.w1_in(w1),.w2_in(w2),.w3_in(w3),
 .done(done),.digit(digit)
);

initial begin
 a0=0;a1=0;a2=0;a3=0;w0=0;w1=0;w2=0;w3=0;
 #20 rst=0;
 #10 start=1;
 #10 start=0;
 repeat(784) begin
   @(negedge clk);
   a0=1;a1=2;a2=3;a3=4;
   w0=1;w1=1;w2=1;w3=1;
 end
 #20;
 $display("MNIST NPU smoke test done=%b digit=%0d",done,digit);
 $finish;
end
endmodule
