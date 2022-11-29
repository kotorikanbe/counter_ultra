//////////////////////////////////////////////////////////////////
//此为倒计时产生器的控制模块，对外接收按钮信号，对内控制rcounter_core//
//////////////////////////////////////////////////////////////////
module rcounter_commander(
    left_button,right_button,up_button,down_button,center_button,min_o,sec_o,ms_10_o,time_out_o,clk_core,target
);
input left_button;
input right_button;
input center_button;
input up_button;
input down_button;
//5个按钮均被使用
input clk_core;//与其他时钟一致，保持100hz
output [7:0] min_o;
output [7:0] sec_o;
output [7:0] ms_10_o;
output time_out_o;//倒计时到0时的信号，实现为led闪烁
output [1:0] target;//在调整倒计时时间时，选择按钮控制哪一位的调整（分，秒，10毫秒），为2'b11时为无效状态
reg [7:0] min_o;
reg [7:0] sec_o;
reg [7:0] ms_10_o;
reg [1:0] target=2'b01;
reg  curr_state=1'b0;//只有两个状态，即工作状态和置数状态
reg  next_state=1'b0;
reg [7:0] min_i=8'b00000101;
reg [7:0] sec_i=8'b00000000;
reg [7:0] ms_10_i=8'b00000000;
wire [7:0] min_o_rcounter;//接受rcounter_core的输出信号
wire [7:0] sec_o_rcounter;
wire [7:0] ms_10_o_rcounter;
reg switch=1'b0;
reg [1:0]next_target=2'b01;//为了不生成锁存器，使用next变量利用时钟跳变沿改变信号
reg [7:0] next_min_i;
reg [7:0] next_sec_i;
reg [7:0] next_ms_10_i;
always @(posedge clk_core) begin
    curr_state<=next_state;
    target<=next_target;
    min_i<=next_min_i;
    sec_i<=next_sec_i;
    ms_10_i<=next_ms_10_i;
end
//0为置数&暂停状态，1为开始计时状态
always @(*) begin
    case (center_button)
        1'b1: begin
            case (curr_state)
                1'b0: begin
                    next_state=1'b1;
                end
                1'b1: begin
                    next_state=1'b0;
                end
                default: next_state=curr_state;
            endcase
        end
        default: next_state=curr_state;
    endcase
end
always @(*) begin//按钮处理模块
    if(!curr_state)
        begin
            switch=1'b0;
            case ({left_button,right_button,up_button,down_button})
                4'b1000: begin//左键控制左移，右键同理
                    if(target<2'b10)begin
                        next_target=target+1'b1;
                    end
                    else begin
                        next_target=target;
                    end
                    next_min_i=min_i;
                    next_sec_i=sec_i;
                    next_ms_10_i=ms_10_i;
                end
                4'b0100: begin
                    if(target>2'b00) begin
                        next_target=target-1'b1;
                    end
                    else begin
                        next_target=target;
                    end
                    next_min_i=min_i;
                    next_sec_i=sec_i;
                    next_ms_10_i=ms_10_i;
                end
                4'b0010:begin
                    next_target=target;
                    case (target)//上下键控制target目标所指向的加减
                        2'b00: begin
                            next_min_i=min_i;
                            next_sec_i=sec_i;
                            if(ms_10_i[3:0]<4'b1001)begin
                                next_ms_10_i[3:0]=ms_10_i[3:0]+1'b1;
                                next_ms_10_i[7:4]=ms_10_i[7:4];
                            end
                            else if(ms_10_i[7:4]<4'b1001)begin
                                next_ms_10_i[3:0]=4'b0000;
                                next_ms_10_i[7:4]=ms_10_i[7:4]+1'b1;
                            end
                            else begin
                                next_ms_10_i=8'b00000000;
                            end
                        end
                        2'b01: begin
                            next_ms_10_i=ms_10_i;
                            next_min_i=min_i;
                            if(sec_i[3:0]<4'b1001)begin
                                next_sec_i[3:0]=sec_i[3:0]+1'b1;
                                next_sec_i[7:4]=sec_i[7:4];
                            end
                            else if(sec_i[7:4]<4'b0101)begin
                                next_sec_i[3:0]=4'b0000;
                                next_sec_i[7:4]=sec_i[7:4]+1'b1;
                            end
                            else begin
                                next_sec_i=8'b00000000;
                            end
                        end
                        2'b10:begin
                            next_ms_10_i=ms_10_i;
                            next_sec_i=sec_i;
                            if(min_i[3:0]<4'b1001)begin
                                next_min_i[3:0]=min_i[3:0]+1'b1;
                                next_min_i[7:4]=min_i[7:4];
                            end
                            else if(min_i[7:4]<4'b1001)begin
                                next_min_i[3:0]=4'b0000;
                                next_min_i[7:4]=min_i[7:4]+1'b1;
                            end
                            else begin
                                next_min_i=8'b00000000;
                            end
                        end
                        default: begin
                            next_min_i=min_i;
                            next_sec_i=sec_i;
                            next_ms_10_i=ms_10_i;
                        end
                    endcase
                end
                4'b0001:begin
                    next_target=target;
                    case (target)
                        2'b00: begin
                            next_min_i=min_i;
                            next_sec_i=sec_i;
                            if(ms_10_i[3:0]>4'b0000) begin
                                next_ms_10_i[3:0]=ms_10_i[3:0]-1'b1;
                                next_ms_10_i[7:4]=ms_10_i[7:4];
                            end
                            else if(ms_10_i[7:4]>4'b0000)begin
                                next_ms_10_i[3:0]=4'b1001;
                                next_ms_10_i[7:4]=ms_10_i[7:4]-1'b1;
                            end
                            else begin
                                next_ms_10_i=8'b10011001;
                            end
                        end
                        2'b01: begin
                            next_min_i=min_i;
                            next_ms_10_i=ms_10_i;
                            if(sec_i[3:0]>4'b0000) begin
                                next_sec_i[3:0]=sec_i[3:0]-1'b1;
                                next_sec_i[7:4]=sec_i[7:4];
                            end
                            else if(sec_i[7:4]>4'b0000)begin
                                next_sec_i[3:0]=4'b1001;
                                next_sec_i[7:4]=sec_i[7:4]-1'b1;
                            end
                            else begin
                                next_sec_i=8'b01011001;
                            end
                        end
                        2'b10:begin
                            next_sec_i=sec_i;
                            next_ms_10_i=ms_10_i;
                            if(min_i[3:0]>4'b0000) begin
                                next_min_i[3:0]=min_i[3:0]-1'b1;
                                next_min_i[7:4]=min_i[7:4];
                            end
                            else if(min_i[7:4]>4'b0000)begin
                                next_min_i[3:0]=4'b1001;
                                next_min_i[7:4]=min_i[7:4]-1'b1;
                            end
                            else begin
                                next_min_i=8'b10011001;
                            end
                        end
                        default: begin
                            next_min_i=min_i;
                            next_sec_i=sec_i;
                            next_ms_10_i=ms_10_i;
                        end
                    endcase
                end
                default: begin//防止生成锁存器，务必完整
                    next_min_i=min_i;
                    next_sec_i=sec_i;
                    next_ms_10_i=ms_10_i;
                    next_target=target;
                end
            endcase//此时显示置数数值而不是计数器输出的数值
            min_o=min_i;
            sec_o=sec_i;
            ms_10_o=ms_10_i;
        end
        else begin//开始计数状态输出计数器的数值
            switch=1'b1;
            next_target=2'b11;
            min_o=min_o_rcounter;
            sec_o=sec_o_rcounter;
            ms_10_o=ms_10_o_rcounter;
            if(center_button)begin
                next_min_i=min_o_rcounter;
                next_sec_i=sec_o_rcounter;
                next_ms_10_i=ms_10_o_rcounter;
                next_target=2'b01;                
            end
            else begin
                next_min_i=min_i;
                next_sec_i=sec_i;
                next_ms_10_i=ms_10_i;
            end
        end
end
rcounter_core main_rcounter(
    .clk_core(~clk_core),
    .min_i(min_i),
    .ms_10_i(ms_10_i),
    .sec_i(sec_i),
    .rst(switch&&(!right_button)),
    .en(switch),
    .min_o(min_o_rcounter),
    .sec_o(sec_o_rcounter),
    .ms_10_o(ms_10_o_rcounter),
    .time_out(time_out_o)
);
endmodule