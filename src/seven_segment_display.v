module seven_segment_display(
    clk,min_i,sec_i,seven_segment_display_o
);
input clk;
input [5:0] min_i;
input [5:0] sec_i;
output [10:0] seven_segment_display_o;
reg [3:0] anode;
reg [6:0] seven_segment;
reg [1:0] sel=2'b00;
reg [3:0] target=4'b0000;
reg [15:0]counts=0 ;
assign seven_segment_display_o={anode,seven_segment};
always @(posedge clk) begin
    counts<=counts+1;
    if(counts[15])begin
        sel<=sel+2'b01;
        counts<=0;
    end
    else ;
end
always @(*) begin
    case (sel)
        2'b00:begin
            anode=4'b0111;
            target=min_i/4'd10;
        end
        2'b01:begin
            anode=4'b1011;
            target=min_i%4'd10;
        end
        2'b10:begin
            anode=4'b1101;
            target=sec_i/4'd10;
        end
        2'b11:begin
            anode=4'b1110;
            target=sec_i%4'd10;
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