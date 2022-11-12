module rcounter_core(
    clk_core,min_i,sec_i,ms_10_i,min_o,sec_o,ms_10_o,rst,en,time_out
);
    input clk_core;
    input [7:0] min_i;
    input [7:0] sec_i;
    input [7:0] ms_10_i;
    input rst;
    input en;
    output [7:0]min_o;
    output [7:0]sec_o;
    output [7:0]ms_10_o;
    output time_out;
    wire [7:0] min_o_counter;
    wire [7:0] sec_o_counter;
    wire [7:0] ms_10_o_counter;
    reg [7:0]min_o;
    reg [7:0]sec_o;
    reg [7:0]ms_10_o;
    reg time_out=1'b0;
    reg flag=1'b0;
    parameter ten =4'b1010 ;
    always @(*) begin
        if(min_i==min_o_counter&&sec_i==sec_o_counter&&ms_10_i==ms_10_o_counter)begin
            time_out=1'b1;
            min_o=8'b00000000;
            sec_o=8'b00000000;
            ms_10_o=8'b00000000;
        end
        else begin
            if(ms_10_i[3:0]<ms_10_o_counter[3:0]) begin
                ms_10_o[3:0]= (ten-ms_10_o_counter[3:0]) +ms_10_i[3:0] ;
                flag=1;
            end
            else begin
                ms_10_o[3:0]= ms_10_i[3:0]-ms_10_o_counter[3:0];
                flag=0;
            end
            if(flag) begin
                if (ms_10_i[7:4]<(ms_10_o_counter[7:4]+4'b0001)) begin
                    ms_10_o[7:4]=(ten-ms_10_o_counter[7:4]-4'b0001)+ms_10_i[7:4];
                    flag=1;
                end
                else begin
                    ms_10_o[7:4]=ms_10_i[7:4]-ms_10_o_counter[7:4]-4'b0001;
                    flag=0;
                end
            end
            else begin
                if (ms_10_i[7:4]<(ms_10_o_counter[7:4])) begin
                    ms_10_o[7:4]=(ten-ms_10_o_counter[7:4])+ms_10_i[7:4];
                    flag=1;
                end
                else begin
                    ms_10_o[7:4]=ms_10_i[7:4]-ms_10_o_counter[7:4];
                    flag=0;
                end                
            end
            if(flag) begin
                if (sec_i[3:0]<(sec_o_counter[3:0]+4'b0001)) begin
                    sec_o[3:0]=(ten-sec_o_counter[3:0]-4'b0001)+sec_i[3:0];
                    flag=1;
                end
                else begin
                    sec_o[3:0]=sec_i[3:0]-sec_o_counter[3:0]-4'b0001;
                    flag=0;
                end
            end
            else begin
                if (sec_i[3:0]<(sec_o_counter[3:0])) begin
                    sec_o[3:0]=(ten-sec_o_counter[3:0])+sec_i[3:0];
                    flag=1;
                end
                else begin
                    sec_o[3:0]=sec_i[3:0]-sec_o_counter[3:0];
                    flag=0;
                end                
            end
            if(flag) begin
                if (sec_i[7:4]<(sec_o_counter[7:4]+4'b0001)) begin
                    sec_o[7:4]=(ten-sec_o_counter[7:4]-4'b0001)+sec_i[7:4];
                    flag=1;
                end
                else begin
                    sec_o[7:4]=sec_i[7:4]-sec_o_counter[7:4]-4'b0001;
                    flag=0;
                end
            end
            else begin
                if (sec_i[7:4]<(sec_o_counter[7:4])) begin
                    sec_o[7:4]=(ten-sec_o_counter[7:4])+sec_i[7:4];
                    flag=1;
                end
                else begin
                    sec_o[7:4]=sec_i[7:4]-sec_o_counter[7:4];
                    flag=0;
                end                
            end
            if(flag) begin
                if (min_i[3:0]<(min_o_counter[3:0]+4'b0001)) begin
                    min_o[3:0]=(ten-min_o_counter[3:0]-4'b0001)+min_i[3:0];
                    flag=1;
                end
                else begin
                    min_o[3:0]=min_i[3:0]-min_o_counter[3:0]-4'b0001;
                    flag=0;
                end
            end
            else begin
                if (min_i[3:0]<(min_o_counter[3:0])) begin
                    min_o[3:0]=(ten-min_o_counter[3:0])+min_i[3:0];
                    flag=1;
                end
                else begin
                    min_o[3:0]=min_i[3:0]-min_o_counter[3:0];
                    flag=0;
                end                
            end
            if(flag) begin
                if (min_i[7:4]<(min_o_counter[7:4]+4'b0001)) begin
                    min_o[7:4]=(ten-min_o_counter[7:4]-4'b0001)+min_i[7:4];
                    flag=1;
                end
                else begin
                    min_o[7:4]=min_i[7:4]-min_o_counter[7:4]-4'b0001;
                    flag=0;
                end
            end
            else begin
                if (min_i[7:4]<(min_o_counter[7:4])) begin
                    min_o[7:4]=(ten-min_o_counter[7:4])+min_i[7:4];
                    flag=1;
                end
                else begin
                    min_o[7:4]=min_i[7:4]-min_o_counter[7:4];
                    flag=0;
                end                
            end
        end
    end
    counter_core rcounter(
        .clk_core(clk_core),
        .en(en),
        .rst(rst),
        .ms_10_o(ms_10_o_counter),
        .sec_o(sec_o_counter),
        .min_o(min_o_counter)
    );
endmodule