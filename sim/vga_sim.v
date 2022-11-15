`timescale 1ns/1ns
module vga_sim();
reg clk=0;
reg [7:0] min_i;
reg [7:0] sec_i;
reg [7:0] ms_10_i;
wire [13:0] vga_display_o;
initial begin
    while (1) begin
        #1 clk=~clk;
    end
end
initial begin
    min_i=0;
    sec_i=0;
    ms_10_i=0;
end
vga_display test(
    .clk(clk),
    .min_i(min_i),
    .sec_i(sec_i),
    .ms_10_i(ms_10_i),
    .vga_display_o(vga_display_o)
);
endmodule
