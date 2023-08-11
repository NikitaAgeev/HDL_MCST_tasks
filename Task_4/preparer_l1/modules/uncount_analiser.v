module uncount_analiser
(
    input wire op_1_NaN,
    input wire op_2_NaN,

    input wire op_1_inf,
    input wire op_2_inf,

    input wire op_1_s,
    input wire op_2_s,

    output wire legal,

    output wire NaN_res,
    output wire inf_res,
    output wire res_sig
);

assign NaN_res = op_1_NaN | op_2_NaN | (op_1_inf & op_2_inf & (op_1_s != op_2_s));
assign inf_res = (op_1_inf | op_2_inf) & ~NaN_res;
assign res_sig = (op_1_s & op_1_inf) | (op_2_s & op_2_inf);

assign legal = ~NaN_res & ~inf_res;

endmodule