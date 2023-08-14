`include "shifter.v"

module mant_preparer
(
    input wire sign_op_1,
    input wire sign_op_2,

    input wire exp_gr_1,
    input wire exp_gr_2,
    input wire exp_eq,

    input wire [7:0]  exp_del,

    input wire [22:0] op_1_f,
    input wire [22:0] op_2_f,

    input wire denorm_op_1,
    input wire denorm_op_2,

    output wire [48:0] op_1_f_pr,
    output wire [48:0] op_2_f_pr  
);


//step_1: ex_forward =========================================================================
wire [24:0] op_1_f_fex;
wire [24:0] op_2_f_fex;

assign op_1_f_fex = (denorm_op_1)? {{2'b00}, {op_1_f}}: {{2'b01}, {op_1_f}};
assign op_2_f_fex = (denorm_op_2)? {{2'b00}, {op_2_f}}: {{2'b01}, {op_2_f}};

//step_2: sign ===============================================================================

wire [24:0] op_1_f_s_pr;
wire [24:0] op_2_f_s_pr;

assign op_1_f_s_pr = (sign_op_1)? ~op_1_f_fex + 1 : op_1_f_fex;
assign op_2_f_s_pr = (sign_op_2)? ~op_2_f_fex + 1 : op_2_f_fex;

//step_3: shift ==============================================================================

wire [7:0] op_1_shift;
wire [7:0] op_2_shift;

assign op_1_shift = (exp_gr_1)? exp_del: 7'b0;
assign op_2_shift = (exp_gr_2)? exp_del: 7'b0;

shifter shifter_op_1 (.in(op_1_f_s_pr), .shift(op_1_shift), .sig(sign_op_1), .out(op_1_f_pr));
shifter shifter_op_2 (.in(op_2_f_s_pr), .shift(op_2_shift), .sig(sign_op_2), .out(op_2_f_pr));

endmodule