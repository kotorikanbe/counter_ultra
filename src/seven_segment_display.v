/////////////////////////////
//此为七段显示管和led控制模块//
////////////////////////////
module seven_segment_display(
    clk,min_i,sec_i,seven_segment_display_o,flick,flick_clk,time_out_i,led_o
);
input clk;
input [7:0] min_i;
input [7:0] sec_i;
input [1:0] flick;//此为闪烁模块，为计时器置数时进行闪烁
input time_out_i;
output [10:0] seven_segment_display_o;
output flick_clk;
output [15:0] led_o;
reg [15:0] led_o;
reg [3:0] anode;
reg [6:0] seven_segment;
reg [1:0] sel=2'b00;
reg [3:0] target=4'b0000;
reg [15:0]counts=0 ;
reg [24:0] flick_counter=0;
reg flick_clk=1'b0;
reg [1:0] flick_state;
reg led_count=0;
assign seven_segment_display_o={anode,seven_segment};
always @(posedge clk) begin//此为时钟分频模块，其快于clk_core
    counts<=counts+1;
    if(counts[15])begin
        sel<=sel+2'b01;
        counts<=0;
    end
    else ;
end
always @(flick) begin//没有必要的模块，历史遗留
    case (flick)
        2'b01: begin
            flick_state=2'b01;
        end
        2'b10: begin
            flick_state=2'b10;
        end
        default: begin
            flick_state=2'b00;
        end
    endcase
end
always @(posedge clk) begin//闪烁分频模块，为了防止瞎眼而设置的位数极高
    flick_counter<=flick_counter+1;
    if(flick_counter[24]) begin
        flick_clk<=~flick_clk;
        flick_counter<=0;
    end
    else ;
end
always @(posedge flick_clk) begin//闪烁模块，利用交替闪烁进行，此闪烁仅在时间为0时进行
    if(led_count&&time_out_i)begin
        led_o<=16'b1010101010101010;
    end
    else if((!led_count)&&time_out_i)begin
        led_o<=16'b0101010101010101;
    end
    else begin
        led_o<=16'b0000000000000000;
    end
    led_count<=~led_count;
end
always @(*) begin//此为7段显示模块，提供显示的数字以及对应的显示码，此外为了实现闪烁，当由闪烁时直接使anode为1无效即可
    case (sel)
        2'b00:begin
            anode={flick_state[1]&&flick_clk,3'b111};
            target=min_i[7:4];
        end
        2'b01:begin
            anode={1'b1,flick_state[1]&&flick_clk,2'b11};
            target=min_i[3:0];
        end
        2'b10:begin
            anode={2'b11,flick_state[0]&&flick_clk,1'b1};
            target=sec_i[7:4];
        end
        2'b11:begin
            anode={3'b111,flick_state[0]&&flick_clk};
            target=sec_i[3:0];
        end
        default: begin
            anode=4'b1111;
            target=4'b0000;
        end
    endcase
    case (target)
        4'b0000: seven_segment<=7'b0000001 ;
        4'b0001: seven_segment<=7'b1001111 ;
        4'b0010: seven_segment<=7'b0010010 ;
        4'b0011: seven_segment<=7'b0000110 ;
        4'b0100: seven_segment<=7'b1001100 ;
        4'b0101: seven_segment<=7'b0100100 ;
        4'b0110: seven_segment<=7'b0100000 ;
        4'b0111: seven_segment<=7'b0001111 ;
        4'b1000: seven_segment<=7'b0000000 ;
        4'b1001: seven_segment<=7'b0000100 ;
        default: seven_segment<=7'b1111111 ;
    endcase
end
endmodule