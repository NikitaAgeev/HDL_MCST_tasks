module shifter(
    input wire [24:0] in,
    input wire [4:0] shift,
    input wire sig,

    output wire [48:0] out
);
wire [48:0] ex_in;

assign ex_in = {{in},{(49-25){1'b0}}};

wire [48:0] pre_out;

assign pre_out = ex_in >> shift;

genvar i;

generate
    for(i = 0; i < 49; i = i + 1) begin
        assign out[i] = (i > (48 - shift))? ((in == 24'b0)? 1'b0: sig): pre_out[i];
    end     
endgenerate

endmodule