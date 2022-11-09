`timescale 1ns/1ns
module counter_commander_sim();
    reg clk=1'b0;
    reg rst=1'b1;
    reg pause=1'b0;
    reg record=1'b0;
    wire [5:0] min_o;
    wire [5:0] sec_o;
    wire [6:0] ms_10_o;
    initial begin
        while(1) begin
            #5
            clk=~clk;
        end
    end
    initial begin
        /*#7
        pause=1'b1;
        #8
        pause=1'b0;
        #10004
        record=1'b1;
        #8
        record=1'b0;
        #10004
        record=1'b1;
        #8
        record=1'b0;
        #10004
        pause=1'b1;
        #8
        pause=1'b0;
         #10004
        record=1'b1;
        #8
        record=1'b0;
        #10004
        pause=1'b1;
        #8
        pause=1'b0;
        #10004
        pause=1'b1;
        #8
        pause=1'b0;
        #10004
        rst=1'b0;
        #8
        rst=1'b1;
        #10004
        pause=1'b1;
        #8
        pause=1'b0;*/
    end
    counter_commander  
    sim_counter
    (
        .clk(clk),
        .rst(rst),
        .pause(pause),
        .record(record),
        .min_o(min_o),
        .sec_o(sec_o),
        .ms_10_o(ms_10_o)
        );
endmodule