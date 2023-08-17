`include "shifter.v"

module mant_preparer
(
    input wire sign_op_1,
    input wire sign_op_2,

    input wire res_sig,

    input wire exp_gr_1,
    input wire exp_gr_2,
    input wire exp_eq,

    input wire [7:0]  exp_del,

    input wire [22:0] op_1_f,
    input wire [22:0] op_2_f,

    input wire denorm_op_1,
    input wire denorm_op_2,

    output wire [49:0] op_1_f_pr,
    output wire [49:0] op_2_f_pr  
);


//step_1: ex_forward =========================================================================
wire [25:0] op_1_f_fex;
wire [25:0] op_2_f_fex;

assign op_1_f_fex = (denorm_op_1)? {{3'b000}, {op_1_f}}: {{3'b001}, {op_1_f}};
assign op_2_f_fex = (denorm_op_2)? {{3'b000}, {op_2_f}}: {{3'b001}, {op_2_f}};

//step_2: sign ===============================================================================

wire [25:0] op_1_f_s_pr;
wire [25:0] op_2_f_s_pr;

assign op_1_f_s_pr = (( sign_op_1 & ~res_sig) | (~sign_op_1 &  res_sig))? ~op_1_f_fex + 1 : op_1_f_fex;
assign op_2_f_s_pr = ((~sign_op_1 &  res_sig) | ( sign_op_1 & ~res_sig))? ~op_2_f_fex + 1 : op_2_f_fex;

//step_3: shift ==============================================================================

wire [7:0] op_1_shift;
wire [7:0] op_2_shift;

assign op_1_shift = (exp_gr_1)? exp_del: 7'b0;
assign op_2_shift = (exp_gr_2)? exp_del: 7'b0;

shifter shifter_op_1 (.in(op_1_f_s_pr), .shift(op_1_shift), .sig(sign_op_1), .out(op_1_f_pr));
shifter shifter_op_2 (.in(op_2_f_s_pr), .shift(op_2_shift), .sig(sign_op_2), .out(op_2_f_pr));

endmodule