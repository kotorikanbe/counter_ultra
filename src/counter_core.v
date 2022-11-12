module counter_core
    (
    clk_core,rst,min_o,sec_o,ms_10_o,en
        );
    input rst;
    input en;
    input clk_core;
    output [7:0]min_o;
    output [7:0]sec_o;
    output [7:0]ms_10_o;
    reg [3:0] data_1=4'b0000 ;
    reg [3:0] data_2=4'b0000 ;
    reg [3:0] data_3=4'b0000;
    reg [3:0] data_4=4'b0000;
    reg [3:0] data_5=4'b0000;
    reg [3:0] data_6=4'b0000;
    reg [7:0]min_o;
    reg [7:0]sec_o;
    reg [7:0]ms_10_o;
    always @(posedge clk_core or negedge rst) begin
        if(!rst)begin
                data_1<=4'b0000;
                data_2<=4'b0000;
                data_3<=4'b0000;
                data_4<=4'b0000;
                data_5<=4'b0000;
                data_6<=4'b0000;
                ms_10_o<={data_2,data_1};
                sec_o<={data_4,data_3};
                min_o<={data_6,data_5};
            end
        else if(en)begin
                if (data_1<4'b1001) begin
                    data_1<=data_1+1'b1;
                    ms_10_o<={data_2,data_1};
                    sec_o<={data_4,data_3};
                    min_o<={data_6,data_5};
                end
                else if(data_2<4'b1001) begin
                    data_2<=data_2+1'b1;
                    data_1<=4'b0000;
                    ms_10_o<={data_2,data_1};
                    sec_o<={data_4,data_3};
                    min_o<={data_6,data_5};
                end
                else if(data_3<4'b1001) begin
                    data_3<=data_3+1'b1;
                    data_1<=4'b0000;
                    data_2<=4'b0000;
                    ms_10_o<={data_2,data_1};
                    sec_o<={data_4,data_3};
                    min_o<={data_6,data_5};
                end
                else if(data_4<4'b0101) begin
                    data_4<=data_4+1'b1;
                    data_1<=4'b0000;
                    data_2<=4'b0000;
                    data_3<=4'b0000;
                    ms_10_o<={data_2,data_1};
                    sec_o<={data_4,data_3};
                    min_o<={data_6,data_5};
                end
                else if(data_5<4'b1001) begin
                    data_5<=data_5+1'b1;
                    data_1<=4'b0000;
                    data_2<=4'b0000;
                    data_3<=4'b0000;
                    data_4<=4'b0000;
                    ms_10_o<={data_2,data_1};
                    sec_o<={data_4,data_3};
                    min_o<={data_6,data_5};
                end
                else if(data_6<4'b1001) begin
                    data_6<=data_6+1'b1;
                    data_1<=4'b0000;
                    data_2<=4'b0000;
                    data_3<=4'b0000;
                    data_4<=4'b0000;
                    data_5<=4'b0000;
                    ms_10_o<={data_2,data_1};
                    sec_o<={data_4,data_3};
                    min_o<={data_6,data_5};
                end
                else begin
                data_1<=4'b0000;
                data_2<=4'b0000;
                data_3<=4'b0000;
                data_4<=4'b0000;
                data_5<=4'b0000;
                data_6<=4'b0000;
                ms_10_o<={data_2,data_1};
                sec_o<={data_4,data_3};
                min_o<={data_6,data_5};
            end
        end
        else ; 
    end
endmodule
