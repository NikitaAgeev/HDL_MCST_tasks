module log(
    input reg [7:0] number,
    output wire [2:0] result
);

wire  offset [7:0];
wire [2:0] midle_res[7:0];



assign midle_res[7] = ((number[7] == 1) && !(number & (8'b11111111 <<8))) ? 3'd7 : 3'd0;
assign midle_res[6] = ((number[6] == 1) && !(number & (8'b11111111 <<7))) ? 3'd6 : 3'd0;
assign midle_res[5] = ((number[5] == 1) && !(number & (8'b11111111 <<6))) ? 3'd5 : 3'd0;
assign midle_res[4] = ((number[4] == 1) && !(number & (8'b11111111 <<5))) ? 3'd4 : 3'd0;
assign midle_res[3] = ((number[3] == 1) && !(number & (8'b11111111 <<4))) ? 3'd3 : 3'd0;
assign midle_res[2] = ((number[2] == 1) && !(number & (8'b11111111 <<3))) ? 3'd2 : 3'd0;
assign midle_res[1] = ((number[1] == 1) && !(number & (8'b11111111 <<2))) ? 3'd1 : 3'd0;
assign midle_res[0] = ((number[0] == 1) && !(number & (8'b11111111 <<1))) ? 3'd0 : 3'd0;


assign result = midle_res[0] | midle_res[1] | midle_res[2] | midle_res[3] | midle_res[4] | midle_res[5] | midle_res[6] | midle_res[7];



endmodule