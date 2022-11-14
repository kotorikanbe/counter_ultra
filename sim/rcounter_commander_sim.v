`timescale 1ns/1ns
module rcounter_commander_sim();
reg left_button;
reg right_button;
reg center_button;
reg up_button;
reg down_button;
reg clk_core=1'b0;
wire [7:0] min_o;
wire [7:0] sec_o;
wire [7:0] ms_10_o;
wire time_out_o;
wire [1:0] target;
initial begin
    while(1) begin
        #5 clk_core=~clk_core;
    end
end
initial begin
    left_button=0;
    right_button=0;
    up_button=0;
    down_button=0;
    center_button=0;
    #10
    center_button=1;
    #10;
end
rcounter_commander test(
    .left_button(left_button),
    .right_button(right_button),
    .up_button(up_button),
    .down_button(down_button),
    .center_button(center_button),
    .clk_core(clk_core),
    .min_o(min_o),
    .sec_o(sec_o),
    .ms_10_o(ms_10_o),
    .time_out_o(time_out_o),
    .target(target)
);
endmodule