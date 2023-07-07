`timescale 1ms/100ps

`include "decoder.v"

module top;

reg clk, reset;

reg [2:0] number;
wire [7:0] result;

decoder test_decoder(.N(number), .result(result));

initial begin
    clk = 0;
    number = 0;
    reset = 0;
end

always begin
    #5 clk = ~clk;
end

always @(posedge clk) begin
    $display("N = %d, result = %b", number, result);
    
    number = number + 1;
    
    if(number == 0) $stop;
end

endmodule