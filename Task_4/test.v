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

adder adder (.op_1(op_1),
             .op_2(op_2),
             .res(res), 
             .clk(clk), 
             .en(en), 
             .val(val)
            );

initial begin
    clk = 0;

    op_1 = {{1'b0}, {8'b111}, {23'b110}};
    op_2 = {{1'b0}, {8'b100}, {23'b1}};
    en = 1;

    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);

    $stop;

end

always begin
    #1 clk = ~clk;
end


endmodule