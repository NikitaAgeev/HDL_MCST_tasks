`timescale 1ns/100ps

`include "mem.v"

module top;

reg clk;

reg [7:0] data;
reg [$clog2(100) -1: 0] addr;
wire [7:0] out; 

reg rd_signal;
reg wr_signal;

wire result;

mem test_mem(.clk(clk),
             .rd_addr(addr),
             .wr_addr(addr),
             .wr_data(data),
             .rd_data(out),
             .rd_en(rd_signal),
             .wr_en(wr_signal));

initial begin
    clk = 1'b1;

    rd_signal = 0;
    wr_signal = 0;

    #1 clk = ~clk; //negedge
    data = 1;
    addr = 2;
    wr_signal = 1;
    
    #1 clk = ~clk; //posedge
    #1 wr_signal = 0;
    #1 clk = ~clk; //negedge

    addr = 2;
    rd_signal = 1;

    #1 clk = ~clk; //posedge

    #1 $display("out = %b", out); 

    #1 clk = ~clk;


end

endmodule