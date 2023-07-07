`timescale 1ns/100ps

`include "Frequency_demultiplier.v"

module top;

reg clk;
reg reset;

wire result;

F_demul test_demul(.clk(clk), .reset(reset), .demul_freq(result));

initial begin
    clk = 1'b0;
    @(posedge clk)
    reset <= 1;
    repeat(3) @(negedge clk);
    reset <= 0;
end

always #1 clk <= ~clk;

always @(posedge clk or negedge clk) begin
    $display("clk = %d", clk);
end

endmodule