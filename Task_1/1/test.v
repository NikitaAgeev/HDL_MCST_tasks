`timescale 1ms/100ps

`include "even.v"

module top;

reg clk, reset;

reg [7:0] number;
wire result;

even test_even(.num(number), .result(result));

initial begin
    clk = 0;
    number = 0;
end

always begin
    #5 clk = ~clk;
end

always @(posedge clk) begin
    if(result == 1) $display("num = %d even", number);
    else $display("num = %d odd", number);
    
    number = number + 1;
    
    if(number == 0) $stop;
end

endmodule
