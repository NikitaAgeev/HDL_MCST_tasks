module post_mant_preparer
(
    input wire [5:0] leading_pos,
    input wire [49:0] unsign_mant,
    input wire [7:0] exp_max,

    output wire [22:0] mant,
    output wire roundoff_bit
);

wire [6:0] norm_leading_pos;
assign norm_leading_pos = 49 - leading_pos;

wire [8:0] exp_max_ex;
assign exp_max_ex = {{1'b0}, {exp_max}};

wire [49:0] pre_pr_mant;
assign pre_pr_mant = ((exp_max_ex + 9'b10) < (norm_leading_pos))? unsign_mant << (exp_max_ex + 9'b11): unsign_mant << (norm_leading_pos + 7'b1);

assign mant = pre_pr_mant[49:(49 - 22)];
assign roundoff_bit = pre_pr_mant[49 - 23]; 

endmodule