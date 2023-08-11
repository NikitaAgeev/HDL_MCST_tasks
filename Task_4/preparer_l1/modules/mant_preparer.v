`include "../../Other_modules/shifter.v"

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

    output wire [47:0] op_1_f_pr,
    output wire [47:0] op_2_f_pr  
);

wire [47:0] op_1_f_pre_pr;
wire [47:0] op_2_f_pre_pr;

assign op_1_f_pre_pr = (denorm_op_1)? {{1'b0}, {op_1_f}, {24'b0}}: {{1'b1}, {op_1_f}, {24'b0}};
assign op_2_f_pre_pr = (denorm_op_2)? {{1'b0}, {op_2_f}, {24'b0}}: {{1'b1}, {op_2_f}, {24'b0}};

wire [4:0] op_1_shift;
wire [4:0] op_2_shift;

assign op_1_shift = (exp_gr_1)? 5'b0: exp_del;
assign op_2_shift = (exp_gr_2)? 5'b0: exp_del;

shifter shifter_op_1(.in(op_1_f_pre_pr), .out(op_1_f_pr), .shift(op_1_shift));
shifter shifter_op_2(.in(op_2_f_pre_pr), .out(op_2_f_pr), .shift(op_2_shift));


endmodule