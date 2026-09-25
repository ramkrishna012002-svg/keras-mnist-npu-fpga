module npu_controller #(parameter K=784)(
    input wire clk, input wire rst, input wire start,
    output reg en, output reg done, output reg [10:0] index
);
always @(posedge clk) begin
    if (rst) begin en<=0; done<=0; index<=0; end
    else begin
        done<=0;
        if (start && !en) begin en<=1; index<=0; end
        else if (en && index==K-1) begin en<=0; done<=1; end
        else if (en) index<=index+1'b1;
    end
end
endmodule
