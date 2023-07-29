//FIFO is made based on the ring list

module FIFO
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

parameter MEMORY_CNT_SIZE = $clog2(FIFO_DEPTH + 1);

reg [MEMORY_CNT_SIZE -1:0] tail;  //tail of ring list 
reg [MEMORY_CNT_SIZE -1:0] head;  //head of ring list

reg [DATA_WIDTH -1:0] mem [FIFO_DEPTH -1:0]; //ring list mem

reg no_full;

assign wr_ready = no_full; //capacity check

always @(posedge clk) begin
    if(reset)
        no_full <= 1;
    else if(wr_en) begin
        if ( (tail + 1 == head) || ( (tail == FIFO_DEPTH) && (head == 0) ) ) begin //capacity check
//           |tail before head|    |  tail before head through overflow  |
            no_full <= 0;
        end
    end
    else if(rd_en & ~no_full)
        no_full <= 1;
end


always @(posedge clk) begin
    if(reset)
        head <= 0;
    else if(rd_en) begin
        if((head != tail) & ~((head == tail) & rd_en)) begin //we have data
//                           |we don't have data at memory, but now we write an read data
            head <= (head < FIFO_DEPTH)? head + 1: 0;        //new head val
                                                             //the ternary operator implements the transition
                                                             //of the head to the top of the list   
        end
    end
end

always @(posedge clk) begin
    if(reset)
        tail <= 0;     
    else if(wr_en & ~((head == tail) & rd_en)) begin    //tail
//                   |we don't have data at memory, but now we write an read data
        tail <= (tail < FIFO_DEPTH)? tail + 1: 0;       //new tail val
                                                        //the ternary operator implements the transition
                                                        //of the tail to the top of the list                   
    end
end



always @(posedge clk) begin
    if(reset)
        rd_val <= 0;
    else if(rd_en) begin
        if(~(head == tail) || wr_en || ~no_full) begin   //we have data
            rd_val <= 1;
        end
        else begin                                       //FIFO is empty
            rd_val <= 0;
        end
    end
end

always @(posedge clk) begin
    if(reset)
        rd_data <= 0;
    else if(rd_en) begin
        if((head != tail) || ~no_full) //we have data
            rd_data <= mem[head];
        else if(wr_en)                 //we don't have data at memory, but now we write and read data
            rd_data <= wr_data;
    end
end

always @(posedge clk) begin
      
    if(wr_en & ~reset & ~((head == tail) & rd_en)) begin
//                       |we don't have data at memory, but now we write an read data
        mem[tail] <= wr_data;
    end
end


endmodule