`timescale 1ms/100ps

`include "log.v"

module top;

reg clk, reset;

reg [7:0] number;
wire [2:0] result;

log test_log(.clk(clk), .number(number), .result(result));

initial begin
    clk = 0;
    number = 0;
    reset = 0;
end

always begin
    #5 clk = ~clk;
end

always @(posedge clk) begin
    $display("N = %b, result = %d", number, result);
    
    number = number + 1;
    
    if(number == 0) $stop;
end

endmodule