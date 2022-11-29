/////////////////////////////////////////////////////
//此模块为时钟分频模块，将100Mhz的时钟分频为100hz的时钟//
/////////////////////////////////////////////////////
module clock_division
#(
    parameter time_scale = 500000 /*1*/
)
(
    clk_i,clk_o
);
input clk_i;
output clk_o;
reg clk_o=1'b0;
reg [20:0] clk_counter=21'b0;
always @(posedge clk_i) begin
            clk_counter<=clk_counter+1;
        if (clk_counter>= time_scale) begin
            clk_o<=~clk_o;
            clk_counter<=0;
        end
        else ;
    end
endmodule