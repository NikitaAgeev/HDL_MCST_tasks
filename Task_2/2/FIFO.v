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

parameter MEMORY_CNT_SIZE = $clog2(FIFO_DEPTH) 

reg [MEMORY_CNT_SIZE -1:0] tale;  //tale of ring list 
reg [MEMORY_CNT_SIZE -1:0] head;  //head of ring list

reg [DATA_WIDTH -1:0] mem [FIFO_DEPTH -1:0]; //ring list mem

assign wr_ready = ( (tale + 1 == head) || ( (tale == FIFO_DEPTH) && (head == 0) ) ) ? 0 : 1; //capacity check
//                  |tale before head|    |  tale before head through overflow  |

always @(posedge clk) begin
    if(reset) begin //reset
        capacity <= 0;
        head <= 0;
        rd_val <= 0;
        rd_data <= 0;4
    end
end
    
always @(posedge clk) begin
    if(rd_en & ~wr_en & ~reset) begin               //read
        if(head != tale) begin                          //we have data
            head <= (head < FIFO_DEPTH)? head + 1: 0;       //new head val
                                                            //the ternary operator implements the transition
                                                            //of the head to the top of the list                   
            rd_data <= mem[head];
            rd_val <= 1;
        end else begin                                  //FIFO is empty
            rd_val <= 0;
        end
    end
end

always @(posedge clk) begin
    if (~rd_en & wr_en & ~reset) begin              //tale
        tale <= (tale < FIFO_DEPTH)? tale + 1: 0;       //new tale val
                                                        //the ternary operator implements the transition
                                                        //of the tale to the top of the list                   
        mem[(tale < FIFO_DEPTH)? tale + 1: 0] <= wr_data;
    end
end

endmodule