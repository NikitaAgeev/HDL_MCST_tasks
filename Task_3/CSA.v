module CSA (
    input wire [64:0] op_1,
    input wire [64:0] op_2,
    input wire [64:0] op_3,

    input wire en,

    output wire [64:0] ps,
    output wire [64:0] pc,

    output wire val
)
     
    assign ps = (en)? op_1 ^ op_2 ^ op_3 : 'b650;
    assign pc = ((op_1 & op_2) | (op_2 & op_3) | (op_1 & op_3)) << 1;
    assign val = en; 

endmodule