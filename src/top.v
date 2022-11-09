module top(
    left_button,rigit_button,center_button,up_button,down_button,clk,mode_swich,display_switch,seven_segment_display_o,VGA_o
    );
    input left_button;
    input rigit_button;
    input up_button;
    input down_button;
    input center_button;
    input clk;
    input mode_swich;
    input display_switch;
    output [10:0] seven_segment_display_o;
    output [20:0] VGA_o;
    wire clk_core;
    wire [5:0] min_o_counter;
    wire [5:0] sec_o_counter;
    wire [6:0] ms_10_o_counter;
    clock_division main_clock_division(
        .clk_i(clk),
        .clk_o(clk_core)
    );
    counter_commander main_counter_commander(
        .clk_core(clk_core),
        .rst((!mode_swich)&&(!right_button)),
        .pause((!mode_swich)&&center_button),
        .record((!mode_swich)&&left_button),
        .min_o(min_o_counter),
        .sec_o(sec_o),
        .ms_10_o(ms_10_o_counter)
    );
endmodule