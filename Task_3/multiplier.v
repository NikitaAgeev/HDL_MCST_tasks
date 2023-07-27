`include "CSA.v"

module multiplier
(
    input wire reset,
    
    input wire clk,
    input wire en,
    input wire [31:0] op1,
    input wire [31:0] op2,

    output reg [63:0] res,
    output reg val,
    output wire overflow
);

wire [32:0] op2_ex;

assign op2_ex = {{op2}, 1'b0}; //expanded op2

reg [63:0] middle_res [(30/2): 0];

reg ctr;

genvar i;
//partial product generator
generate
    for(i = 31; i > 0; i = i - 2) begin: loop
        always @(posedge clk) begin
            if(en) begin
            middle_res[(i-1)/2] <= ( (op2_ex[i+1:i-1] == 3'b001) || (op2_ex[i+1:i-1] == 3'b010) ) ?  {{(32+1 - i){1'b0}}, {op1}, {(i-1){1'b0}}}    : //     op1 << i-1
                                   ( (op2_ex[i+1:i-1] == 3'b011)                                ) ?  {{(32+0 - i){1'b0}}, {op1}, {(i){1'b0}}}      : //  2*(op1 << i-1)
                                   ( (op2_ex[i+1:i-1] == 3'b101) || (op2_ex[i+1:i-1] == 3'b110) ) ? ~{{(32+1 - i){1'b0}}, {op1}, {(i-1){1'b0}}} + 1: //   -(op1 << i-1)
                                   ( (op2_ex[i+1:i-1] == 3'b100)                                ) ? ~{{(32+0 - i){1'b0}}, {op1}, {(i){1'b0}}}   + 1: // -2*(op1 << i-1)
                                   64'b0;                                                                                                            //     0
            end
        end
    end 
endgenerate


//big CSA
// 1 layer
wire [63:0] layer_1_result [9:0];
CSA CSA_0_1(.op1(middle_res[0]), .op2(middle_res[1]), .op3(middle_res[2]), .ps(layer_1_result[0]), .pc(layer_1_result[1]));
CSA CSA_1_1(.op1(middle_res[3]), .op2(middle_res[4]), .op3(middle_res[5]), .ps(layer_1_result[2]), .pc(layer_1_result[3]));
CSA CSA_2_1(.op1(middle_res[6]), .op2(middle_res[7]), .op3(middle_res[8]), .ps(layer_1_result[4]), .pc(layer_1_result[5]));
CSA CSA_3_1(.op1(middle_res[9]), .op2(middle_res[10]), .op3(middle_res[11]), .ps(layer_1_result[6]), .pc(layer_1_result[7]));
CSA CSA_4_1(.op1(middle_res[12]), .op2(middle_res[13]), .op3(middle_res[14]), .ps(layer_1_result[8]), .pc(layer_1_result[9]));
//no 0_15

// 2 layer
wire [63:0] layer_2_result [5:0];
CSA CSA_0_2(.op1(layer_1_result[0]), .op2(layer_1_result[1]), .op3(layer_1_result[2]), .ps(layer_2_result[0]), .pc(layer_2_result[1]));
CSA CSA_1_2(.op1(layer_1_result[3]), .op2(layer_1_result[4]), .op3(layer_1_result[5]), .ps(layer_2_result[2]), .pc(layer_2_result[3]));
CSA CSA_2_2(.op1(layer_1_result[6]), .op2(layer_1_result[7]), .op3(layer_1_result[8]), .ps(layer_2_result[4]), .pc(layer_2_result[5]));
//no 0_15 and 1_9

// 3 layer
wire [63:0] layer_3_result [3:0];
CSA CSA_0_3(.op1(layer_2_result[0]), .op2(layer_2_result[1]), .op3(layer_2_result[2]), .ps(layer_3_result[0]), .pc(layer_3_result[1]));
CSA CSA_1_3(.op1(layer_2_result[3]), .op2(layer_2_result[4]), .op3(layer_2_result[5]), .ps(layer_3_result[2]), .pc(layer_3_result[3]));
//no 0_15 and 1_9

// 4 layer
wire [63:0] layer_4_result [3:0];
CSA CSA_0_4(.op1(layer_3_result[0]), .op2(layer_3_result[1]), .op3(layer_3_result[2]), .ps(layer_4_result[0]), .pc(layer_4_result[1]));
CSA CSA_1_4(.op1(layer_3_result[3]), .op2(middle_res[15]), .op3(layer_1_result[9]), .ps(layer_4_result[2]), .pc(layer_4_result[3]));

// 5 layer
wire [63:0] layer_5_result [1:0];
CSA CSA_0_5(.op1(layer_4_result[0]), .op2(layer_4_result[1]), .op3(layer_4_result[2]), .ps(layer_5_result[0]), .pc(layer_5_result[1]));

// 6 layer
wire [63:0] layer_6_result [1:0];
CSA CSA_0_6(.op1(layer_5_result[0]), .op2(layer_5_result[1]), .op3(layer_4_result[3]), .ps(layer_6_result[0]), .pc(layer_6_result[1]));


assign overflow = ~(res[63:32] == 33'b0);

always @(posedge clk) begin
    if(reset)
        ctr <= 0;
    else begin
        if(en)
            ctr <= 1;
        if(ctr & ~en)
            ctr <= 0;
    end
end

always @(posedge clk) begin
    if(reset)
        val <= 0;
    else begin
        if(en & ~ctr)
            val <= 0;
        if(ctr)
            val <= 1;
    end
end

always @(posedge clk) begin
    if(ctr & ~reset)
        res <= layer_6_result[1] + layer_6_result[0];
end

endmodule