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

reg [$clog2(FIFO_DEPTH) -1:0] capacity;  //number of ring list items 
reg [$clog2(FIFO_DEPTH) -1:0] head;      //head of ring list

reg [DATA_WIDTH -1:0] mem [FIFO_DEPTH -1:0]; //ring list mem

assign wr_ready = (capacity > FIFO_DEPTH) ? 0 : 1; //capacity check

always @(posedge clk) begin
    if(reset == 1) begin //reset
        capacity <= 0;
        head <= 0;
        rd_val <= 0;
        rd_data <= 0;

    end else if((rd_en == 1) && (wr_en == 0)) begin  //read
        if(capacity > 0) begin                          //we have data
            head <= (head < FIFO_DEPTH)? head + 1: 0;       //new head val
                                                            //the ternary operator implements the transition
                                                            //of the head to the top of the list
            capacity <= capacity - 1;                   
            rd_data <= mem[head];
            rd_val <= 1;
        end else begin                                  //FIFO is empty
            rd_val <= 0;
        end
    end else if ((rd_en == 0)&&(wr_en == 1)) begin
        if((capacity < FIFO_DEPTH) || (capacity == FIFO_DEPTH)) begin
            capacity <= capacity + 1;
            mem[((head + capacity) < FIFO_DEPTH)? head + capacity: head + capacity - FIFO_DEPTH] <= wr_data;
            //   |checking data for overflow   |  |no overflow  |  |overflow                  |
            //take data from ring list
        end
    end
end

endmodule