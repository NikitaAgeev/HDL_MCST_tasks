//FIFO is made based on the shear list

module shear_FIFO
#(
    parameter FIFO_DEPTH = 100,
    parameter DATA_WIDTH = 8
)
(
    input wire clk,
    input wire reset,

    input wire rd_en,
    output reg [DATA_WIDTH -1:0] rd_data,
    output reg rd_val,
    
    input wire wr_en,
    input wire [DATA_WIDTH -1:0] wr_data,
    output reg wr_ready
);

parameter MEMORY_CNT_SIZE = $clog2(FIFO_DEPTH);

reg [MEMORY_CNT_SIZE -1:0] tail;  //tail of shear list 


reg [DATA_WIDTH -1:0] mem [FIFO_DEPTH -1:0]; //ring list mem

assign wr_ready = tail < FIFO_DEPTH;


always @(posedge clk) begin
    if(reset)
        tail <= 0;     
    else if(wr_en & ~rd_en)              
        tail <= tail + 1;             
    else if(rd_en & ~wr_en)begin
        if(tail != 0)
            tail <= tail - 1;
    end
end


always @(posedge clk) begin
    if(reset)
        rd_val <= 0;
    else if(rd_en) begin
        if((tail != 0) || wr_en)    //we have data
            rd_val <= 1;
        else                        //FIFO is empty
            rd_val <= 0;
    end
end

always @(posedge clk) begin
    if(reset)
        rd_data <= 0;
    else if(rd_en) begin
        if(tail != 0)            //we have data
            rd_data <= mem[0];
        else if(wr_en)
            rd_data <= wr_data;
    end
end

genvar i;

generate
for(i = 0; i < FIFO_DEPTH - 1; i = i + 1) begin: loop
    always @(posedge clk) begin    
        if(rd_en & ~reset)
                mem[i] <= mem[i + 1];
        if(wr_en & ~rd_en & ~reset & (tail == i))
            mem[i] <= wr_data;
        if(wr_en & rd_en & (tail != 0) & (tail - 1 == i))
            mem[i] <= wr_data;
    end
end
endgenerate



endmodule