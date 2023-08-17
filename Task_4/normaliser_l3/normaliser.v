`include"modules/Counter_leading_1.v"
`include"modules/exp_preparer.v"
`include"modules/post_mant_preparer.v"

module normaliser
(
    input wire sig,
    input wire [7:0] exp_max,
    input wire [49:0] pre_pr_mant,

    input wire NaN_res,
    input wire inf_res,

    output wire [31:0] res
);


// module ===============================================
wire [49:0] unsign_mant;
assign unsign_mant = (sig)? ~pre_pr_mant + 1: pre_pr_mant;
//=======================================================

// counter_leading_1 ====================================
wire [$clog2(50) -1:0] leading_pos;
wire zero_mant;

counter_leading_1 counter_leading_1 (.in(pre_pr_mant),
                                     .sig(sig),
                                     .leading_pos(leading_pos),
                                     .zero_in(zero_mant)
);
//=======================================================

// exp_prepared =========================================
wire [7:0] exp;
wire overflow;

exp_preparer exp_preparer (.leading_pos(leading_pos),
                           .exp_max(exp_max),
                           .exp(exp),
                           .overflow(overflow)
                           );
//=======================================================

// mant_preparer ========================================
wire [21:0] mant;

post_mant_preparer post_mant_preparer (.leading_pos(leading_pos),
                             .unsign_mant(unsign_mant),
                             .exp_max(exp_max),
                             .mant(mant)
                             );
//=======================================================

// res_constractor ======================================
assign res = (NaN_res) ? {{1'b0}, {~8'b0}, {~22'b0}}:
             (inf_res) ? {{sig} , {~8'b0}, {22'b0} }:
             (overflow)? {{sig} , {~8'b0}, {22'b0} }: 
                         {{sig} , {exp}  , {mant}  };
//=======================================================


endmodule