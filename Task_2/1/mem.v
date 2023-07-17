module mem
#(
    parameter DATA_WIDTH = 8,
    parameter MAX_ADR = 100,
    parameter ADDRSIZE = $clog2(MAX_ADR)
)
(
    input wire clk,
    
    input wire rd_en,
    input wire [ADDRSIZE -1: 0] rd_addr,
    output reg [DATA_WIDTH -1: 0] rd_data,

    input wire wr_en,
    input wire [ADDRSIZE -1: 0] wr_addr,
    input wire [DATA_WIDTH -1: 0] wr_data
);

reg [DATA_WIDTH -1:0] memory_arr [MAX_ADR -1:0];

always @(posedge clk) begin
    if(rd_en & ~wr_en))
        rd_data <= memory_arr[rd_addr];
    else if(wr_en & ~rd_en)
        memory_arr[wr_addr] <= wr_data;

end 

endmodule