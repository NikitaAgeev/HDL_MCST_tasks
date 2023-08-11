`include "modules/decoder.v"
`include "modules/exp_analiser.v"
`include "modules/mant_preparer.v"
`include "modules/sign_analiser.v"
`include "modules/uncount_analiser.v"

module preparer
(
    input wire [31:0] op_1,
    input wire [31:0] op_2,

    //input [31:0] wire en;

    output wire NaN_res,
    output wire inf_res,
    output wire res_sig,
    output wire legal,

    output wire [7:0] exp_max,

    output wire [47:0] mant_op_1,
    output wire [47:0] mant_op_2
    
);


//decoder =====================================
//op_1
wire        op_1_s;
wire [7:0]  op_1_e;
wire [22:0] op_1_f;

wire op_1_NaN;
wire op_1_denorm;
wire op_1_inf;

decoder op_1_decoder(.op     (op_1),
                     .op_s   (op_1_s),
                     .op_e   (op_1_e), 
                     .op_f   (op_1_f),
                     .NaN    (op_1_NaN),
                     .inf    (op_1_inf),
                     .denorm (op_1_denorm)
                     );

//op_2
wire        op_2_s;
wire [7:0]  op_2_e;
wire [22:0] op_2_f;

wire op_2_NaN;
wire op_2_denorm;
wire op_2_inf;

decoder op_2_decoder(.op     (op_2),
                     .op_s   (op_2_s),
                     .op_e   (op_2_e), 
                     .op_f   (op_2_f),
                     .NaN    (op_2_NaN),
                     .inf    (op_2_inf),
                     .denorm (op_2_denorm)
                     );
//=============================================

//uncount_analiser ============================
wire res_sig_unleg;

uncount_analiser uncount_analiser (.op_1_NaN(op_1_NaN),
                                   .op_2_NaN(op_2_NaN),
                                   .op_1_inf(op_1_inf),
                                   .op_2_inf(op_2_inf),
                                   .op_1_s(op_1_s),
                                   .op_2_s(op_2_s),
                                   .legal(legal),
                                   .NaN_res(NaN_res),
                                   .inf_res(inf_res),
                                   .res_sig(res_sig_unleg)    
                                   );
//=============================================

//exp_analiser ================================
wire [7:0] del;

wire gr_1;
wire gr_2;
wire eq;

exp_analiser exp_analiser (.exp_1(op_1_e),
                           .exp_2(op_2_e),
                           .exp_max(exp_max),
                           .del(del),
                           .gr_1(gr_1),
                           .gr_2(gr_2),
                           .eq(eq)
);
//=============================================

//mant_preparer ===============================
mant_preparer mant_preparer (.sign_op_1(op_1_s),
                             .sign_op_2(op_2_s),
                             .exp_gr_1(gr_1),
                             .exp_gr_2(gr_2),
                             .exp_eq(eq),
                             .op_1_f(op_1_f),
                             .op_2_f(op_2_f),
                             .denorm_op_1(op_1_denorm),
                             .denorm_op_2(op_2_denorm),
                             .op_1_f_pr(mant_op_1),
                             .op_2_f_pr(mant_op_2),
                             .exp_del(del)
                             );
//=============================================

//sign_anoliser ===============================
wire res_sig_leg;

sign_analiser sign_analiser (.sign_op_1(op_1_s),
                             .sign_op_2(op_2_s),
                             .exp_gr_1(gr_1),
                             .exp_gr_2(gr_2),
                             .exp_eq(eq),
                             .op_1_f(op_1_f),
                             .op_2_f(op_2_f),
                             .res_sign(res_sig_leg)
                             );
//=============================================

//res_sig
assign res_sig = (legal)? res_sig_leg: res_sig_unleg;


endmodule