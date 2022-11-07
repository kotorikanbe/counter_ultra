`timescale 1ns / 1ns
module counter_core_sim(

    );
    reg clk=0;
    reg rst=1;
    wire [5:0]min_o;
    wire [5:0]sec_o;
    wire [6:0]ms_10_o;
    initial begin
        while (1) begin
            #5
            clk=~clk;
        end
    end
    counter_core #(.time_scale(1)) test
    (
        .clk(clk),
        .rst(rst),
        .min_o(min_o),
        .sec_o(sec_o),
        .ms_10_o(ms_10_o)
    );

endmodule
