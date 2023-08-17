`include "preparer_l1/preparer.v"
`include "normaliser_l3/normaliser.v"

module adder 
(
    input wire [31:0] op_1,
    input wire [31:0] op_2,

    output reg [31:0] res,

    input wire clk,
    input wire en,

    output reg val
);

// preperer ===============================
wire w_NaN_res;
wire w_inf_res;

wire w_sig;
wire [7:0] w_exp_max;

wire [49:0] w_mant_op_1;
wire [49:0] w_mant_op_2;

preparer preparer (.op_1(op_1),
                   .op_2(op_2),
                   .NaN_res(w_NaN_res),
                   .inf_res(w_inf_res),
                   .res_sig(w_sig),
                   .exp_max(w_exp_max),
                   .mant_op_1(w_mant_op_1),
                   .mant_op_2(w_mant_op_2)
                   );

// saver===================================

reg en_l1;

reg NaN_res_l1;
reg inf_res_l1;

reg sig_l1;
reg [7:0] exp_max_l1;

reg [49:0] mant_op_1_l1;
reg [49:0] mant_op_2_l1;

always @(posedge clk) begin
    en_l1 <= en;
end

always @(posedge clk) begin
    if(en) NaN_res_l1 <= w_NaN_res;
end

always @(posedge clk) begin
    if(en) inf_res_l1 <= w_inf_res;
end

always @(posedge clk) begin
    if(en) sig_l1 <= w_sig;
end

always @(posedge clk) begin
    if(en) exp_max_l1 <= w_exp_max;
end

always @(posedge clk) begin
    if(en) mant_op_1_l1 <= w_mant_op_1;
end

always @(posedge clk) begin
    if(en) mant_op_2_l1 <= w_mant_op_2;
end

//=========================================

// adder ==================================
wire [49:0] summ;

assign summ = mant_op_1_l1 + mant_op_2_l1;

// saver===================================

reg en_l2;

reg NaN_res_l2;
reg inf_res_l2;

reg sig_l2;
reg [7:0] exp_max_l2;

reg [49:0] summ_l2;

always @(posedge clk) begin
    en_l2 <= en_l1;
end

always @(posedge clk) begin
    if(en_l1) NaN_res_l2 <= NaN_res_l1;
end

always @(posedge clk) begin
    if(en_l1) inf_res_l2 <= inf_res_l1;
end

always @(posedge clk) begin
    if(en_l1) sig_l2 <= sig_l1;
end

always @(posedge clk) begin
    if(en_l1) exp_max_l2 <= exp_max_l1;
end

always @(posedge clk) begin
    if(en_l1) summ_l2 <= summ;
end

//=========================================

// normaliser =============================
wire [31:0] w_res;

normaliser normaliser (.sig(sig_l2),
                       .exp_max(exp_max_l2),
                       .pre_pr_mant(summ_l2),
                       .NaN_res(NaN_res_l2),
                       .inf_res(inf_res_l2),
                       .res(w_res)
                       );
//saver ===================================

always @(posedge clk) begin
    val <= en_l2;
end

always @(posedge clk) begin
    res <= w_res;
end

//=========================================

endmodule