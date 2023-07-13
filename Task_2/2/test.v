`timescale 1ns/100ps

`include "FIFO.v"

module top;

reg clk;
reg reset;

reg rd_sig;
reg wr_sig;

wire rd_val;
wire wr_ready;

reg [7:0] data_in;
wire [7:0] data_out;


FIFO test_FIFO(.clk(clk),
               .reset(reset),
               .rd_en(rd_sig),
               .wr_en(wr_sig),
               .rd_val(rd_val),
               .wr_ready(wr_ready),
               .rd_data(data_out),
               .wr_data(data_in)
               );

initial begin
    rd_sig = 0;
    wr_sig = 0;
    data_in = 0;

    clk = 1'b0;
    reset = 1;
    #1 clk = ~clk; //posedge
    #1 reset = 0;
    #1 clk = ~clk; //negedge

    data_in = 10;
    wr_sig = 1;
    #1 clk = ~clk; //posedge
    #1 wr_sig = 0;
    #1 clk = ~clk; //negedge

    rd_sig = 1;
    #1 clk = ~clk; //posedge
    #1 rd_sig = 0;
    #1 clk = ~clk; //negedge
    $display("out = %b", data_out);

end


endmodule