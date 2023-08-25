module exp_preparer
(
    input wire [5:0] leading_pos,
    input wire [7:0] exp_max,

    output wire [7:0] exp,
    output wire overflow
);

wire [6:0] norm_leading_pos;
assign norm_leading_pos = 49 - leading_pos;

wire [8:0] exp_max_ex;
assign exp_max_ex = {{1'b0}, {exp_max}};

assign exp = ((exp_max_ex + 9'b10) < (norm_leading_pos))? 8'b0: exp_max - norm_leading_pos + 8'b11;
assign overflow = ((exp_max + 8'b11) >= ({{1'b0}, {~8'b0}} +  norm_leading_pos));


endmodule