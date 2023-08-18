`timescale 1ns/100ps

`include "adder.v"

module top;

reg clk;
reg reset;

reg en;

reg [31:0] op_1;
reg [31:0] op_2;

wire [31:0] res;
wire val;

shortreal real_op_1;
shortreal real_op_2;

shortreal my_ans;
shortreal real_ans;

adder adder (.op_1(op_1),
             .op_2(op_2),
             .res(res), 
             .clk(clk), 
             .en(en), 
             .val(val)
            );

initial begin
    clk = 0;

    real_op_1 = 13.1204130342342040234;
    real_op_2 = 12.23451352113;

    op_1 = $shortrealtobits(real_op_1);
    op_2 = $shortrealtobits(real_op_2);
    
    en = 1;

    @(posedge clk);
    op_1 = {{1'b0}, {~8'b0}, {23'b0}};
    op_2 = {{1'b1}, {~8'b0}, {23'b0}};
    @(posedge clk);
    op_1 = {{1'b0}, {~8'b0}, {23'b1}};
    op_2 = {{1'b0}, {8'b0}, {23'b1}};
    @(posedge clk);
    op_1 = {{1'b0}, {~8'b0}, {23'b0}};
    op_2 = {{1'b0}, {8'b0}, {23'b1}};
    @(posedge clk);
    my_ans = $bitstoshortreal(res);
    real_ans = real_op_1 + real_op_2;
    $display("my_ans = %f, real_ans = %f", my_ans, real_ans);
    @(posedge clk);
    my_ans = $bitstoshortreal(res);
    $display("my_res = %f, real_ans = NaN", my_ans);
    @(posedge clk);
    my_ans = $bitstoshortreal(res);
    $display("my_res = %f, real_ans = NaN", my_ans);
    @(posedge clk);
    my_ans = $bitstoshortreal(res);
    $display("my_res = %f, real_ans = +inf", my_ans);
    

    $stop;

end

always begin
    #1 clk = ~clk;
end


endmodule