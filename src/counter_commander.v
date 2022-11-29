///////////////////////////////////////////////////////////////////
//此为秒表控制模块，其对外接收按钮信号，对内操控clk_core实现秒表功能。//
//////////////////////////////////////////////////////////////////
module counter_commander
    (
        clk_core,rst,pause,record,min_o,sec_o,ms_10_o
        );
    input clk_core;
    input rst;
    input pause;
    input record;
    output [7:0] min_o;
    output [7:0] sec_o;
    output [7:0] ms_10_o;
    reg switch=1'b0;
    wire [7:0] min_o_r;
    wire [7:0] sec_o_r;
    wire [7:0] ms_10_o_r;
    wire clk_core;
    reg [1:0]curr_state=2'b00;//一共有四个状态
    reg [1:0]next_state=2'b00;
    reg [7:0] min_o;
    reg [7:0] sec_o;
    reg [7:0] ms_10_o;
    always @(posedge clk_core) begin
        curr_state<=next_state;
    end
    always @(*) begin
        case ({pause,record})
            2'b10: begin
                case (curr_state)//pause按钮控制是否暂停，其在state变量中为第0位
                    2'b00: next_state=2'b01;
                    2'b01: next_state=2'b00;
                    2'b10: next_state=2'b11;
                    2'b11: next_state=2'b10;
                    default: next_state=curr_state;
                endcase
            end
            2'b01:begin//record按钮为记录按钮，其逻辑为在秒表运行时按下进入记录模式，此时秒表显示按下record时的时间，而在暂停状态下按下则进入正常秒表模式。
                case (curr_state)
                    2'b01: next_state=2'b11;
                    2'b10: next_state=2'b00;
                    default: next_state=curr_state;
                endcase
            end
            default: next_state=curr_state;
        endcase
    end
    always @(*) begin//显见其为mealy模型
        if(!curr_state[1])begin//这里会生成latch，但考虑record功能可知，这个latch正是record按钮想要的效果
            min_o=min_o_r;
            sec_o=sec_o_r;
            ms_10_o=ms_10_o_r;
        end
        else if (record) begin
            min_o=min_o_r;
            sec_o=sec_o_r;
            ms_10_o=ms_10_o_r;
        end
        else ;
        switch=curr_state[0];
    end
    counter_core main_counter(
        .clk_core(clk_core),
        .rst(!rst),
        .en(switch),
        .min_o(min_o_r),
        .sec_o(sec_o_r),
        .ms_10_o(ms_10_o_r)
    );
endmodule