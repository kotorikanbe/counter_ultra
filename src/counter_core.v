module counter_core
    #(parameter time_scale = 500000)
    (
    clk,rst,min_o,sec_o,ms_10_o
        );
    input clk;
    input rst;
    output min_o;
    output sec_o;
    output ms_10_o;
    reg clk_core=1'b0;
    reg [20:0] clk_counter=0;
    reg [5:0] min_o=6'b000000;
    reg [5:0] sec_o=6'b000000;
    reg [6:0] ms_10_o=7'b0000000;
    always @(posedge clk) begin

        
            clk_counter<=clk_counter+1;
            
        if (clk_counter>= time_scale) begin
            clk_core<=~clk_core;
            clk_counter<=0;
        end
    end
    always @(posedge clk_core or negedge rst) begin
        if(!rst)begin
            min_o<=6'b000000;
            sec_o<=6'b000000;
            ms_10_o<=7'b0000000;
        end
        else begin
            if (ms_10_o<99) begin
                ms_10_o<=ms_10_o+1'b1;
            end
            else if(sec_o<59) begin
                sec_o<=sec_o+1'b1;
                ms_10_o<=7'b0000000;
            end
            else if(min_o<59) begin
                min_o<=min_o+1;
                sec_o<=6'b000000;
                ms_10_o<=7'b0000000;
            end
            else begin
                min_o<=6'b000000;
                sec_o<=6'b000000;
                ms_10_o<=7'b0000000;
            end
        end
    end
endmodule
