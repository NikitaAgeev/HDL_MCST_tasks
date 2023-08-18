module decoder
(
    input wire [31:0] op,

    output wire        op_s,
    output wire [7:0]  op_e,
    output wire [22:0] op_f,

    output wire NaN,
    output wire inf,
    output wire denorm
);

//splitter
assign op_s = op[31];
assign op_e = op[30:23];
assign op_f = op[22:0];

//status decoder
assign NaN    = (op_e == 8'b11111111) & (op_f != 23'b0);
assign inf    = (op_e == 8'b11111111) & (op_f == 23'b0);
assign denorm = (op_e == 8'b0);

endmodule