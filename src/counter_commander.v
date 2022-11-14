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
    wire [7:0] min_o_r=8'b00000000;
    wire [7:0] sec_o_r=8'b00000000;
    wire [7:0] ms_10_o_r=8'b00000000;
    wire clk_core;
    reg [1:0]curr_state=2'b00;
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
                    2'b01: next_state=2'b11;
                    2'b10: next_state=2'b00;
                    default: next_state=curr_state;
                endcase
            end
            default: next_state=curr_state;
        endcase
    end
    always @(*) begin
        if(!curr_state[1])begin
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