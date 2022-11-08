module counter_core
    #(parameter time_scale = 500000)
    (
    clk_core,rst,min_o,sec_o,ms_10_o,en
        );
    input rst;
    input en;
    input clk_core;
    output min_o;
    output sec_o;
    output ms_10_o;
    reg [5:0] min_o=6'b000000;
    reg [5:0] sec_o=6'b000000;
    reg [6:0] ms_10_o=7'b0000000;
    always @(posedge clk_core or negedge rst) begin
        if(en&&rst)begin
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
        else if(!rst)begin
                min_o<=6'b000000;
                sec_o<=6'b000000;
                ms_10_o<=7'b0000000;
            end
    end
endmodule
