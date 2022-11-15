`timescale 1ns/1ns
module rcounter_core_sim();
reg rst;
reg en;
reg clk=1'b0;
reg [7:0] min;
reg [7:0] sec;
reg [7:0] ms;
wire [7:0] min_o;
wire [7:0] sec_o;
wire [7:0] ms_o;
wire timeout;
initial begin
    while(1) begin
        #5 clk=~clk;
    end
end
initial begin
    en=1'b1;
    rst=1'b1;
    min=8'd10;
    sec=8'd10;
    ms=8'd10;
end
rcounter_core test(
    .clk_core(clk),
    .rst(rst),
    .en(en),
    .min_i(min),
    .sec_i(sec),
    .ms_10_i(ms),
    .min_o(min_o),
    .sec_o(sec_o),
    .ms_10_o(ms_o),
    .time_out(time_out)
);
endmodule