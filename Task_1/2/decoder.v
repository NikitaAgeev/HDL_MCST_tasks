module decoder(
    input wire [2:0]  N,
    output wire [7:0] result
);

assign    result = 8'b1 << N;

endmodule