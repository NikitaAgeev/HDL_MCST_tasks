module shifter(
    input wire [47:0] in,
    input wire [4:0] shift,

    output wire [47:0] out
);

wire [47:0] layers [3:0];

assign layers[0] = (shift[0])? in >> 1: in;
assign layers[1] = (shift[1])? layers[0] >> 2: layers[0];
assign layers[2] = (shift[2])? layers[1] >> 4: layers[1];
assign layers[3] = (shift[3])? layers[2] >> 8: layers[2];
assign out = (shift[4])? layers[3] >> 8: layers[3];

endmodule