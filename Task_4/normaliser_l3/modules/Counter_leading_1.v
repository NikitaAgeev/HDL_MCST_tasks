module  counter_leading_1
#(
    parameter IN_SIZE = 50,
    parameter OUT_SIZE = $clog2(IN_SIZE)
)
(
    input wire [IN_SIZE -1:0] in,
    input wire sig,

    output wire [OUT_SIZE -1:0] leading_pos,
    output wire zero_in
);

// make_pre_pr_in =========================================
wire [IN_SIZE -1:0] pre_pr_in;

assign pre_pr_in = (sig)? ~in: in;

// find_leading_1 =========================================
genvar i;

wire find_leading_res [IN_SIZE:0];
wire [OUT_SIZE:0] leading_pos_arr [IN_SIZE:0];

assign find_leading_res [IN_SIZE] = 1'b0;
assign leading_pos_arr  [IN_SIZE] = 49; 


generate
    for(i = 0; i < IN_SIZE; i = i + 1) begin
        assign leading_pos_arr[i] = (find_leading_res[i + 1])? leading_pos_arr[i + 1]: i;
        assign find_leading_res[i] = (pre_pr_in[i] | find_leading_res[i + 1]);
    end
endgenerate

wire [5:0] pre_leading_pos;
assign pre_leading_pos = leading_pos_arr[0];

//=========================================================

// find_last_0 ============================================
wire find_last_res [IN_SIZE -1:0];
wire [OUT_SIZE:0] last_pos_arr [IN_SIZE -1:0];

assign find_last_res[0] = ~pre_pr_in[0];
assign last_pos_arr[0] = 6'b0; 


generate
    for(i = 1; i < IN_SIZE; i = i + 1) begin
        assign last_pos_arr[i] = (find_last_res[i - 1])? last_pos_arr[i - 1]: i;
        assign find_last_res[i] = (~pre_pr_in[i] | find_last_res[i - 1]);
    end
endgenerate

wire [OUT_SIZE:0] pre_last_pos;
assign pre_last_pos = last_pos_arr [IN_SIZE -1];

//=========================================================

// find real leading_pos ==================================
assign leading_pos = (sig)? ((pre_last_pos -1 == pre_leading_pos)? pre_last_pos: pre_leading_pos): pre_leading_pos;
assign zero_in = ~find_leading_res[0];


endmodule