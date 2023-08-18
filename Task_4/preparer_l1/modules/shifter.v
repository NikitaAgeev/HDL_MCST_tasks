module shifter(
    input wire [25:0] in,
    input wire [7:0] shift,
    input wire sig,

    output wire [49:0] out
);
wire [49:0] ex_in;

assign ex_in = {{in},{(50-26){1'b0}}};

wire [49:0] pre_out;

assign pre_out = ex_in >> shift;

genvar i;

generate
    for(i = 0; i < 50; i = i + 1) begin
        assign out[i] = (i > (49 - shift))? ((in == 26'b0)? 1'b0: sig): pre_out[i];
    end     
endgenerate

endmodule