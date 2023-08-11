module sign_analiser
(
    input wire sign_op_1,
    input wire sign_op_2,

    input wire exp_gr_1,
    input wire exp_gr_2,
    input wire exp_eq,

    input wire [22:0] op_1_f,
    input wire [22:0] op_2_f,

    output wire res_sign
);

assign res_sign = (exp_eq)? ((op_1_f > op_2_f)? sign_op_1: sign_op_2): ((exp_gr_1)? sign_op_1: sign_op_2); 

endmodule