`include "CSA.v"

module multiplier
(
    input wire clk,
    input wire en,
    input wire [31:0] op1,
    input wire [31:0] op2,

    output reg [31:0] res,
    output reg val,
    output wire overflow
);

wire [34:0] op2_ex;

assign op2_ex = {2{0}, op2, 0}; //expanded op2

wire [31+32+1:0] middle_res [(32/2) +1: 0];

reg ctr;

genvar i;
//partial product generator
generate
    for(i = 32; i > 0; i = i - 2) begin: loop
        assign middle_res[i] = ( (op2_ex[i+1:i-1] == 3'b001) or (op2_ex[i+1:i-1] == 3'b010) ) ? {32+1 - i{0}, op1, i{0}}:
                               ( ((op2_ex[i+1:i-1] == 3'b011)) ) ? {32 - i{0}, op1, i+1{0}}:
                               ( (op2_ex[i+1:i-1] == 3'b101) or (op2_ex[i+1:i-1] == 3'b110) ) ? ~{32+1 - i{0}, op1, i{0}} + 1:
                               ( ((op2_ex[i+1:i-1] == 3'b100)) ) ? ~{32 - i{0}, op1, i+1{0}} + 1:
                               65'b0;
    end 
endgenerate


//big CSA
// 1 layer
wire [64:0] layer_1_result [11:0];
CSA CSA_0_1(.op1(middle_res[0]), .op2(middle_res[1]), .op3(middle_res[2]), .ps(layer_1_result[0]), .pc(layer_1_result[1]));
CSA CSA_1_1(.op1(middle_res[3]), .op2(middle_res[4]), .op3(middle_res[5]), .ps(layer_1_result[2]), .pc(layer_1_result[3]));
CSA CSA_2_1(.op1(middle_res[6]), .op2(middle_res[7]), .op3(middle_res[8]), .ps(layer_1_result[4]), .pc(layer_1_result[5]));
CSA CSA_3_1(.op1(middle_res[9]), .op2(middle_res[10]), .op3(middle_res[11]), .ps(layer_1_result[6]), .pc(layer_1_result[7]));
CSA CSA_4_1(.op1(middle_res[12]), .op2(middle_res[13]), .op3(middle_res[14]), .ps(layer_1_result[8]), .pc(layer_1_result[9]));
CSA CSA_5_1(.op1(middle_res[15]), .op2(middle_res[16]), .op3(middle_res[17]), .ps(layer_1_result[10]), .pc(layer_1_result[11]));

// 2 layer
wire [64:0] layer_2_result [7:0];
CSA CSA_0_2(.op1(layer_1_result[0]), .op2(layer_1_result[1]), .op3(layer_1_result[2]), .ps(layer_2_result[0]), .pc(layer_2_result[1]));
CSA CSA_1_2(.op1(layer_1_result[3]), .op2(layer_1_result[4]), .op3(layer_1_result[5]), .ps(layer_2_result[2]), .pc(layer_2_result[3]));
CSA CSA_2_2(.op1(layer_1_result[6]), .op2(layer_1_result[7]), .op3(layer_1_result[8]), .ps(layer_2_result[4]), .pc(layer_2_result[5]));
CSA CSA_3_2(.op1(layer_1_result[9]), .op2(layer_1_result[10]), .op3(layer_1_result[11]), .ps(layer_2_result[6]), .pc(layer_2_result[7]));

// 3 layer
wire [64:0] layer_3_result [3:0];
CSA CSA_0_3(.op1(layer_2_result[0]), .op2(layer_2_result[1]), .op3(layer_2_result[2]), .ps(layer_3_result[0]), .pc(layer_3_result[1]));
CSA CSA_1_3(.op1(layer_2_result[3]), .op2(layer_2_result[4]), .op3(layer_2_result[5]), .ps(layer_3_result[2]), .pc(layer_3_result[3]));

// 4 layer
wire [64:0] layer_4_result [3:0];
CSA CSA_0_4(.op1(layer_3_result[0]), .op2(layer_3_result[1]), .op3(layer_3_result[2]), .ps(layer_4_result[0]), .pc(layer_4_result[1]));
CSA CSA_1_4(.op1(layer_3_result[3]), .op2(layer_2_result[6]), .op3(layer_2_result[7]), .ps(layer_4_result[2]), .pc(layer_4_result[3]));

// 5 layer
wire [64:0] layer_5_result [1:0];
CSA CSA_0_5(.op1(layer_4_result[0]), .op2(layer_4_result[1]), .op3(layer_4_result[2]), .ps(layer_5_result[0]), .pc(layer_5_result[1]));

// 6 layer
wire [64:0] layer_6_result [1:0];
CSA CSA_0_5(.op1(layer_5_result[0]), .op2(layer_5_result[1]), .op3(layer_4_result[3]), .ps(layer_6_result[0]), .pc(layer_6_result[1]));

reg [64:0] ov_check_reg;
assign overflow = ~(ov_check_reg[64:32] == 33'b0) 


always @(posedge clk) begin
    if(val) begin
        overflow <= 1;
        val <= 0;
        ctr <= 1;
    end

    if(ctr) begin
        ctr <= 0;
        val <= 1;
        overflow <= layer_6_result[1] + layer_6_result[0];
        res <= layer_6_result[1] + layer_6_result[0];
    end

    
    
end

endmodule