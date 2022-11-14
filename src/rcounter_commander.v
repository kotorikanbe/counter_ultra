module rcounter_commander(
    left_button,right_button,up_button,down_button,center_button,min_o,sec_o,ms_10_o,time_out_o,clk_core,target
);
input left_button;
input right_button;
input center_button;
input up_button;
input down_button;
input clk_core;
output [7:0] min_o;
output [7:0] sec_o;
output [7:0] ms_10_o;
output time_out_o;
output [1:0] target;
reg [7:0] min_o;
reg [7:0] sec_o;
reg [7:0] ms_10_o;
reg [1:0] target=2'b01;
reg  curr_state=1'b0;
reg  next_state=1'b0;
reg [7:0] min_i=8'b00000101;
reg [7:0] sec_i=8'b00000000;
reg [7:0] ms_10_i=8'b00000000;
wire [7:0] min_o_rcounter;
wire [7:0] sec_o_rcounter;
wire [7:0] ms_10_o_rcounter;
reg switch=1'b0;
reg [1:0]next_target=2'b01;
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
always @(*) begin
    if(!curr_state)
        begin
            switch=1'b0;
            case ({left_button,right_button,up_button,down_button})
                4'b1000: begin
                    if(target<2'b10)begin
                        next_target=target+1'b1;
                    end
                    else ;
                end
                4'b0100: begin
                    if(target>2'b00) begin
                        next_target=target-1'b1;
                    end
                end
                4'b0010:begin
                    case (target)
                        2'b00: begin
                            if(ms_10_i[3:0]<4'b1001)begin
                                next_ms_10_i=ms_10_i+1'b1;
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
                            if(sec_i[3:0]<4'b1001)begin
                                next_sec_i=sec_i+1'b1;
                            end
                            else if(sec_i[7:4]<4'b0110)begin
                                next_sec_i[3:0]=4'b0000;
                                next_sec_i[7:4]=sec_i[7:4]+1'b1;
                            end
                            else begin
                                next_sec_i=8'b00000000;
                            end
                        end
                        2'b10:begin
                            if(min_i[3:0]<4'b1001)begin
                                next_min_i=min_i+1'b1;
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
                    case (target)
                        2'b00: begin
                            if(ms_10_i[3:0]>4'b0000) begin
                                next_ms_10_i[3:0]=ms_10_i[3:0]-1'b1;
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
                            if(sec_i[3:0]>4'b0000) begin
                                next_sec_i[3:0]=sec_i[3:0]-1'b1;
                            end
                            else if(sec_i[7:4]>4'b0000)begin
                                next_sec_i[3:0]=4'b1001;
                                next_sec_i[7:4]=sec_i[7:4]-1'b1;
                            end
                            else begin
                                next_sec_i=8'b01101001;
                            end
                        end
                        2'b10:begin
                            if(min_i[3:0]>4'b0000) begin
                                next_min_i[3:0]=min_i[3:0]-1'b1;
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
                default: begin
                    next_min_i=min_i;
                    next_sec_i=sec_i;
                    next_ms_10_i=ms_10_i;
                    next_target=target;
                end
            endcase
            min_o=min_i;
            sec_o=sec_i;
            ms_10_o=ms_10_i;
        end
        else begin
            switch=1'b1;
            target=2'b11;
            min_o=min_o_rcounter;
            sec_o=sec_o_rcounter;
            ms_10_o=ms_10_o_rcounter;
            if(center_button)begin
                next_min_i=min_o_rcounter;
                next_sec_i=sec_o_rcounter;
                next_ms_10_i=ms_10_o_rcounter;
                next_target=2'b01;                
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