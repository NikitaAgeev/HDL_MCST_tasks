module F_demul
#(
    parameter PERIOD = 6,
    parameter ON_TIME = PERIOD/2,
    parameter COUNTER_SIZE = $clog(PERIOD)
)
(
    input reg clk,
    input wire reset,

    output reg demul_freq
);

reg [COUNTER_SIZE -1 :0] counter;

always @(posedge clk) begin
    
    if (reset == 1) begin
        counter <= 0;
        demul_freq = 1;
    end
    else begin
        case (counter)
            PERIOD: begin
                demul_freq <= 1;
                counter <= 0;
            end
            ON_TIME: begin
                demul_freq <= 0;
                counter <= counter + 1;
            end 

            default: counter <= counter + 1;
        endcase
    end

end

endmodule

