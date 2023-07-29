`timescale 1ns/100ps

`include "FIFO.v"
`include "shear_FIFO.v"

module top;

reg clk;
reg reset;

reg rd_sig;
reg wr_sig;

wire rd_val;
wire wr_ready;

reg [7:0] data_in;
wire [7:0] data_out;
wire [7:0] data_out_2;



FIFO test_FIFO(.clk(clk),
               .reset(reset),
               .rd_en(rd_sig),
               .wr_en(wr_sig),
               .rd_val(rd_val),
               .wr_ready(wr_ready),
               .rd_data(data_out),
               .wr_data(data_in)
               );

shear_FIFO test_FIFO_2(.clk(clk),
                       .reset(reset),
                       .rd_en(rd_sig),
                       .wr_en(wr_sig),
                       .rd_val(rd_val),
                       .wr_ready(wr_ready),
                       .rd_data(data_out_2),
                       .wr_data(data_in)
                       );

initial begin
    rd_sig = 0;
    wr_sig = 0;
    data_in = 0;
    clk = 1'b0;

    @(posedge clk) reset = 1;
    
    @(negedge clk) reset = 1;

    @(posedge clk) reset = 1;
    
    @(negedge clk) begin
        reset = 0;
        data_in <= 11;
        
        wr_sig <= 1;
        rd_sig <= 1;
    end    
    @(posedge clk) begin
        #1 $display("in data = %d | out data = [%d,%d]", data_in, data_out, data_out_2);
    end

    @(negedge clk) begin
        //wr_sig <= 0;
        data_in <= 12;

        rd_sig <= 0;
        wr_sig <= 1;
    end
    @(posedge clk) begin
        #1 $display("in data = %d", data_in);
    end

    @(negedge clk) begin
        data_in <= 13;
        
        rd_sig <= 0;
        wr_sig <= 1;
    end
    @(posedge clk) begin
        #1 $display("in data = %d", data_in);
    end

    @(negedge clk) begin
        //data_in <= 14;
        
        wr_sig <= 0;
        rd_sig <= 1;
    end
    @(posedge clk) begin
        #1 $display("out data = [%d,%d]", data_out, data_out_2);
    end

    @(negedge clk) begin
        reset = 0;
        data_in <= 15;
        
        wr_sig <= 1;
        rd_sig <= 1;
    end    
    @(posedge clk) begin
        #1 $display("in data = %d | out data = [%d,%d]", data_in, data_out, data_out_2);
    end

    @(negedge clk) begin
        rd_sig <= 0;
        wr_sig <= 0;
    end

    $stop;
end

always begin
#5 clk = ~clk;
end

endmodule