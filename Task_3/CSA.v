module CSA (
    input wire [64:0] op1,
    input wire [64:0] op2,
    input wire [64:0] op3,

    output wire [64:0] ps,
    output wire [64:0] pc
);
     
    assign ps =  op1 ^ op2 ^ op3;
    assign pc = ((op1 & op2) | (op2 & op3) | (op1 & op3)) << 1;

endmodule