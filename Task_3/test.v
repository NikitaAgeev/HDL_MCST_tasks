`timescale 1ns/100ps

`include "multiplier.v"

module top;

reg clk;
reg reset;

wire out;
reg in;
wire over;

reg [31:0] data_1;
reg [31:0] data_2;
wire [64:0] data_out;


multiplier test_mul(.clk(clk),
                    .op1(data_1),
                    .op2(data_2),
                    .res(data_out),
                    .en(in),
                    .val(out),
                    .overflow(over),
                    .reset(reset)
                    );

initial begin
    data_1 = 0;
    data_2 = 0;
    in = 0;
    clk = 0;

    @(posedge clk)
    reset <= 1;
    repeat(3) @(negedge clk);
    reset <= 0;


    @(negedge clk) begin
        data_1 <= 48;
        data_2 <= 56;
        in <= 1;
    end
    @(posedge clk)
    @(posedge clk)
    @(negedge clk) begin
        in <= 0;
        $display("res = %d, real res = %d", data_out, data_1*data_2);
    end
    
    @(posedge clk)
    @(posedge clk)

    @(posedge clk) $stop;


end

always begin
    #1 clk = ~clk;
end


endmodule