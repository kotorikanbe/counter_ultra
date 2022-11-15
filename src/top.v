module top(
    left_button,right_button,center_button,up_button,down_button,clk,mode_switch,seven_segment_display_o,vga_display_o
    );
    input left_button;
    input right_button;
    input up_button;
    input down_button;
    input center_button;
    input clk;
    input mode_switch;
    output [10:0] seven_segment_display_o;
    output [13:0] vga_display_o;
    wire clk_core;
    wire [7:0] min_o_counter;
    wire [7:0] sec_o_counter;
    wire [7:0] ms_10_o_counter;
    wire left_button_p;
    wire rigit_button_p;
    wire up_button_p;
    wire down_button_p;
    wire center_button_p;
    wire [7:0] min_o_rcounter;
    wire [7:0] sec_o_rcounter;
    wire [7:0] ms_10_o_rcounter;
    wire time_out_o_rcounter;
    wire [1:0]target_o_rcounter;
    reg [7:0] min_o_sel;
    reg [7:0] sec_o_sel;
    reg [7:0] ms_10_o_sel;
    reg [1:0] target_o_sel;
    reg time_out_o_sel;
    wire flick_clk;
    vga_display main_vga_display(
        .clk(clk),
        .min_i(min_o_sel),
        .sec_i(sec_o_sel),
        .ms_10_i(ms_10_o_sel),
        .vga_display_o(vga_display_o),
        .flick(target_o_sel),
        .flick_clk(flick_clk)
    );
    always @(*) begin
        if(!mode_switch) begin
            min_o_sel=min_o_counter;
            sec_o_sel=sec_o_counter;
            ms_10_o_sel=ms_10_o_counter;
            target_o_sel=2'b11;
            time_out_o_sel=1'b0;
        end
        else begin
            min_o_sel=min_o_rcounter;
            sec_o_sel=sec_o_rcounter;
            ms_10_o_sel=ms_10_o_rcounter;
            target_o_sel=target_o_rcounter;
            time_out_o_sel=time_out_o_rcounter;
        end
    end
    clock_division main_clock_division(
        .clk_i(clk),
        .clk_o(clk_core)
    );
    counter_commander main_counter_commander(
        .clk_core(clk_core),
        .rst((!mode_switch)&&right_button_p),
        .pause((!mode_switch)&&center_button_p),
        .record((!mode_switch)&&left_button_p),
        .min_o(min_o_counter),
        .sec_o(sec_o_counter),
        .ms_10_o(ms_10_o_counter)
    );
    rcounter_commander main_rcounter_commander(
        .left_button(mode_switch&&left_button_p),
        .right_button(mode_switch&&right_button_p),
        .center_button(mode_switch&&center_button_p),
        .up_button(mode_switch&&up_button_p),
        .down_button(mode_switch&&down_button_p),
        .clk_core(clk_core),
        .min_o(min_o_rcounter),
        .sec_o(sec_o_rcounter),
        .ms_10_o(ms_10_o_rcounter),
        .time_out_o(time_out_o_rcounter),
        .target(target_o_rcounter)
    );
    seven_segment_display main_seven_segment_display(
        .clk(clk),
        .min_i(min_o_sel),
        .sec_i(sec_o_sel),
        .seven_segment_display_o(seven_segment_display_o),
        .flick(target_o_sel),
        .flick_clk(flick_clk)
    );
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
endmodule