module counter_commander
    #(parameter time_scale = 500000)
    (
        clk,rst,pause,record,min_o,sec_o,ms_10_o
        );
    input clk;
    input rst;
    input pause;
    input record;
    output [5:0] min_o;
    output [5:0] sec_o;
    output [6:0] ms_10_o;
    wire switch=1'b0;
    reg [5:0] min_o_r;
    reg [5:0] sec_o_r;
    reg [6:0] ms_10_o_r;
    reg [20:0] clk_counter=0;
    reg clk_core=1'b0;
    reg [1:0]curr_state=2'b00;
    reg [1:0]next_state=2'b00;
    always @(posedge clk) begin
            clk_counter<=clk_counter+1;
        if (clk_counter>= time_scale) begin
            clk_core<=~clk_core;
            clk_counter<=0;
        end
    end
    always @(posedge clk_core) begin
        curr_state<=next_state;
    end
    always @(*) begin
        case ({pause,record})
            2'b10: begin
                case (curr_state)
                    2'b00: next_state=2'b01;
                    2'b01: next_state=2'b00;
                    2'b10: next_state=2'b11;
                    2'b11: next_state=2'b10;
                    default: next_state=curr_state;
                endcase
            end
            2'b01:begin
                case (curr_state)
                    2'b00: next_state=2'b10;
                    2'b10: next_state=2'b00;
                    2'b01: next_state=2'b11;
                    2'b11: next_state=2'b01;
                    default: next_state=curr_state;
                endcase
            end
            default: next_state=curr_state;
        endcase
    end
    assign switch=curr_state[0];
    counter_core main_counter(
        .clk_core(clk_core),
        .rst(rst),
        .en(switch),
        .min_o(min_o_r),
        .sec_o(sec_o_r),
        .ms_10_o(ms_10_o_r)
    );
endmodule