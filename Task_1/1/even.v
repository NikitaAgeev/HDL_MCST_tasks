

module even (
    input reg [7:0] num,
    output wire result
);

assign result = ~num[0];

endmodule
