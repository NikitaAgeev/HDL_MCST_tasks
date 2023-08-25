module  counter_leading_1
#(
    parameter IN_SIZE = 50,
    parameter OUT_SIZE = $clog2(IN_SIZE)
)
(
    input wire [IN_SIZE -1:0] in, 

    output wire [OUT_SIZE -1:0] leading_pos,
    output wire zero_in
);


genvar i;

wire find_leading_res [IN_SIZE:0];
wire [OUT_SIZE:0] leading_pos_arr [IN_SIZE:0];

assign find_leading_res [IN_SIZE] = 1'b0;
assign leading_pos_arr  [IN_SIZE] = 49; 


generate
    for(i = 0; i < IN_SIZE; i = i + 1) begin
        assign leading_pos_arr[i] = (find_leading_res[i + 1])? leading_pos_arr[i + 1]: i;
        assign find_leading_res[i] = (in[i] | find_leading_res[i + 1]);
    end
endgenerate

assign leading_pos = leading_pos_arr[0];

assign zero_in = ~find_leading_res[0];


endmodule