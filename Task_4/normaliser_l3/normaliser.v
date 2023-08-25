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

    output wire [31:0] res,

    output wire [4:0] exept
);


// counter_leading_1 ====================================
wire [$clog2(50) -1:0] leading_pos;
wire zero_mant;

counter_leading_1 counter_leading_1 (.in(pre_pr_mant),
                                     .leading_pos(leading_pos),
                                     .zero_in(zero_mant)
);
//=======================================================

// exp_prepared =========================================
wire [7:0] pre_exp;
wire pre_overflow;

exp_preparer exp_preparer (.leading_pos(leading_pos),
                           .exp_max(exp_max),
                           .exp(pre_exp),
                           .overflow(pre_overflow)
                           );
//=======================================================

// mant_preparer ========================================
wire [22:0] pre_mant;
wire roundoff_bit;

post_mant_preparer post_mant_preparer (.leading_pos(leading_pos),
                             .unsign_mant(pre_pr_mant),
                             .exp_max(exp_max),
                             .mant(pre_mant),
                             .roundoff_bit(roundoff_bit)
                             );
//=======================================================

// roundoff =============================================
wire [7:0] exp;
wire [22:0] mant;
wire overflow;

wire roundoff_over;
assign roundoff_over = (mant == ~23'b0) & (roundoff_bit);

assign exp = (roundoff_over)? pre_exp + 8'b1: pre_exp;
assign mant = pre_mant + {{22'b0}, {roundoff_bit}};
assign overflow = ((exp == (~8'b0 - 8'b1) & roundoff_over) | pre_overflow); 

//=======================================================

// res_constractor ======================================
assign res = (NaN_res) ? {{1'b0}, {~8'b0}, {~23'b0}}:
             (inf_res) ? {{sig} , {~8'b0}, {23'b0} }:
             (overflow)? {{sig} , {~8'b0}, {23'b0} }: 
                         {{sig} , {exp}  , {mant}  };
//=======================================================

// exept ================================================
assign exept[0] = NaN_res;                          //invalid
assign exept[1] = 1'b0;                             //divby0
assign exept[2] = overflow;                         //overflow
assign exept[3] = (exp == 8'b0);                    //underflow
assign exept[4] = overflow & ~pre_overflow;         //inexact
//=======================================================

endmodule