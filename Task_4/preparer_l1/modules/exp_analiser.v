module exp_analiser
(
    input wire [7:0] exp_1,
    input wire [7:0] exp_2, 

    output wire [7:0] exp_max,
    output wire [7:0] del,

    output wire gr_1,
    output wire gr_2,
    output wire eq
);

assign exp_max = (exp_1 > exp_2)? exp_1 : exp_2;
assign gr_1    = (exp_1 > exp_2);
assign gr_2    = (exp_2 > exp_1);
assign eq      = (exp_1 == exp_2);

assign del = (exp_1 > exp_2)? exp_1 - exp_2 : exp_2 - exp_1; 


endmodule