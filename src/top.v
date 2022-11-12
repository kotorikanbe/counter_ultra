module top(
    left_button,right_button,center_button,up_button,down_button,clk,mode_switch,display_switch,seven_segment_display_o
    );
    input left_button;
    input right_button;
    input up_button;
    input down_button;
    input center_button;
    input clk;
    input mode_switch;
    input display_switch;
    output [10:0] seven_segment_display_o;
    wire clk_core;
    wire [7:0] min_o_counter;
    wire [7:0] sec_o_counter;
    wire [7:0] ms_10_o_counter;
    wire left_button_p;
    wire rigit_button_p;
    wire up_button_p;
    wire down_button_p;
    wire center_button_p;
    button_anti_tremble left(
        .button_i(left_button),
        .button_o(left_button_p),
        .clk_core(clk_core)
    );
    button_anti_tremble right(
        .button_i(right_button),
        .button_o(right_button_p),
        .clk_core(clk_core)
    );
    button_anti_tremble up(
        .button_i(up_button),
        .button_o(up_button_p),
        .clk_core(clk_core)
    );
    button_anti_tremble down(
        .button_i(down_button),
        .button_o(down_button_p),
        .clk_core(clk_core)
    );
    button_anti_tremble center(
        .button_i(center_button),
        .button_o(center_button_p),
        .clk_core(clk_core)
    );
    clock_division main_clock_division(
        .clk_i(clk),
        .clk_o(clk_core)
    );
    counter_commander main_counter_commander(
        .clk_core(clk_core),
        .rst(!right_button_p),
        .pause(center_button_p),
        .record(left_button_p),
        .min_o(min_o_counter),
        .sec_o(sec_o_counter),
        .ms_10_o(ms_10_o_counter)
    );
    seven_segment_display main_seven_segment_display(
        .clk(clk),
        .min_i(min_o_counter),
        .sec_i(sec_o_counter),
        .seven_segment_display_o(seven_segment_display_o)
    );
endmodule