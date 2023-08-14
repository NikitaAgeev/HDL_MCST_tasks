`timescale 1ns/100ps

`include "preparer_l1/preparer.v"

module top;

reg clk;
reg reset;

reg [31:0] op_1;
reg [31:0] op_2;

wire NaN_res;
wire inf_res;
wire res_sig;
wire legal;

wire [7:0] exp_max;

wire [48:0] mant_op_1;
wire [48:0] mant_op_2;

preparer preparer (.op_1(op_1),
                   .op_2(op_2),
                   .NaN_res(NaN_res),
                   .inf_res(inf_res),
                   .res_sig(res_sig),
                   .legal(legal),
                   .exp_max(exp_max),
                   .mant_op_1(mant_op_1),
                   .mant_op_2(mant_op_2)
);

initial begin
    clk = 0;

    op_1 = {{1'b1}, {8'b111}, {23'b1}};
    op_2 = {{1'b0}, {8'b100}, {23'b1}};

    @(posedge clk);
    @(posedge clk);

    $stop;

end

always begin
    #1 clk = ~clk;
end


endmodule