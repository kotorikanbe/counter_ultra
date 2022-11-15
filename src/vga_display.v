module vga_display(
    clk,min_i,sec_i,ms_10_i,vga_display_o,flick,flick_clk
);
input clk;
input flick_clk;
input [7:0] min_i;
input [7:0] sec_i;
input [7:0] ms_10_i;
input [1:0] flick;
output [13:0] vga_display_o;
reg [13:0] vga_display_o=0;
wire h_sync;
wire v_sync;
reg clk_vga=0;
reg count=0;
reg [10:0] h_count=0;
reg [10:0] v_count=0;
reg [3:0] data_R_sel=4'b0000;
reg [3:0] data_G_sel=4'b0000;
reg [3:0] data_B_sel=4'b0000;
reg [7:0] min_i_r=8'b0;
reg [7:0] sec_i_r=8'b0;
reg [7:0] ms_10_i_r=8'b0;
reg [13:0] data_addr=0;
reg [2:0] flag=3'b000;
wire end1;
wire end2;
reg [3:0] data_R=0;
reg [3:0] data_G=0;
reg [3:0] data_B=0;
wire data_en;
wire [11:0] data_o_0;
wire [11:0] data_o_1;
wire [11:0] data_o_2;
wire [11:0] data_o_3;
wire [11:0] data_o_4;
wire [11:0] data_o_5;
wire [11:0] data_o_6;
wire [11:0] data_o_7;
wire [11:0] data_o_8;
wire [11:0] data_o_9;
wire [11:0] data_o_sep;
parameter hsync_end = 10'd95;
parameter hdat_begin = 10'd143;
parameter hdat_end = 10'd783;
parameter hpixel_end = 10'd799;
parameter vsync_end = 10'd1;
parameter vdat_begin = 10'd34;
parameter vdat_end = 10'd514;
parameter vline_end = 10'd524;
parameter v_ram_begin =10'd199 ;
parameter v_ram_end = 10'd349;
always @(posedge clk) begin
    if(count==1)begin
        clk_vga<=~clk_vga;
        count<=0;
    end
    else begin
        count<=count+1;
    end
end
always @(posedge clk_vga) begin
    if(end1)begin
        h_count<=10'd0;
    end
    else begin
        h_count<=h_count+10'd1;
    end
end
assign end1=(h_count==hpixel_end);
always @(posedge clk_vga ) begin
    if(end1)begin
        if(end2)begin
            v_count<=10'd0;
        end
        else begin
            v_count<=v_count+10'd1;
        end
    end
end
assign end2=(v_count==vline_end);
assign h_sync=(h_count>hsync_end);
assign v_sync=(v_count>vsync_end);
assign data_en=(v_count>v_ram_begin)&&(v_count<=v_ram_end)&&(h_count>=hdat_begin)&&(h_count<hdat_end);
always @(*) begin
    if(! v_sync) begin
    min_i_r=min_i;
    sec_i_r=sec_i;
    ms_10_i_r=ms_10_i;
    end
end
always @(*) begin
    if(!data_en)begin
        data_addr=14'b0;
    end
    else begin
        if((h_count>=hdat_begin)&&(h_count<hdat_begin+10'd80))begin
            data_addr=h_count-hdat_begin+(v_count-v_ram_begin-1)*14'd80;
            flag=3'b000;
        end
        else if((h_count>=hdat_begin+10'd80)&&(h_count<hdat_begin+10'd160))begin
            data_addr=h_count-hdat_begin-10'd80+(v_count-v_ram_begin-1)*14'd80;
            flag=3'b001;
        end
        else if((h_count>=hdat_begin+10'd160)&&(h_count<hdat_begin+10'd240))begin
            data_addr=h_count-hdat_begin-10'd160+(v_count-v_ram_begin-1)*14'd80;
            flag=3'b010;
        end
        else if((h_count>=hdat_begin+10'd240)&&(h_count<hdat_begin+10'd320))begin
            data_addr=h_count-hdat_begin-10'd240+(v_count-v_ram_begin-1)*14'd80;
            flag=3'b011;
        end
        else if ((h_count>=hdat_begin+10'd320)&&(h_count<hdat_begin+10'd400)) begin
            data_addr=h_count-hdat_begin-10'd320+(v_count-v_ram_begin-1)*14'd80;
            flag=3'b100;
        end
        else if ((h_count>=hdat_begin+10'd400)&&(h_count<hdat_begin+10'd480)) begin
            data_addr=h_count-hdat_begin-10'd400+(v_count-v_ram_begin-1)*14'd80;
            flag=3'b101;
        end
        else if ((h_count>=hdat_begin+10'd480)&&(h_count<hdat_begin+10'd560)) begin
            data_addr=h_count-hdat_begin-10'd480+(v_count-v_ram_begin-1)*14'd80;
            flag=3'b110;
        end
        else if ((h_count>=hdat_begin+10'd560)&&(h_count<hdat_begin+10'd640)) begin
            data_addr=h_count-hdat_begin-10'd560+(v_count-v_ram_begin-1)*14'd80;
            flag=3'b111;
        end
        else begin
            data_addr=14'b0;
            flag=3'b000;
        end
    end
end
blk_mem_gen_0 ram_0 (
  .clka(clk_vga),    // input wire clka
  .ena(1),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(data_addr),  // input wire [13 : 0] addra
  .dina(12'b0),    // input wire [11 : 0] dina
  .douta(data_o_0)  // output wire [11 : 0] douta
);
blk_mem_gen_1 ram_1 (
  .clka(clk_vga),    // input wire clka
  .ena(1),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(data_addr),  // input wire [13 : 0] addra
  .dina(12'b0),    // input wire [11 : 0] dina
  .douta(data_o_1)  // output wire [11 : 0] douta
);
blk_mem_gen_2 ram_2 (
  .clka(clk_vga),    // input wire clka
  .ena(1),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(data_addr),  // input wire [13 : 0] addra
  .dina(12'b0),    // input wire [11 : 0] dina
  .douta(data_o_2)  // output wire [11 : 0] douta
);
blk_mem_gen_3 ram_3 (
  .clka(clk_vga),    // input wire clka
  .ena(1),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(data_addr),  // input wire [13 : 0] addra
  .dina(12'b0),    // input wire [11 : 0] dina
  .douta(data_o_3)  // output wire [11 : 0] douta
);
blk_mem_gen_4 ram_4 (
  .clka(clk_vga),    // input wire clka
  .ena(1),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(data_addr),  // input wire [13 : 0] addra
  .dina(12'b0),    // input wire [11 : 0] dina
  .douta(data_o_4)  // output wire [11 : 0] douta
);
blk_mem_gen_5 ram_5 (
  .clka(clk_vga),    // input wire clka
  .ena(1),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(data_addr),  // input wire [13 : 0] addra
  .dina(12'b0),    // input wire [11 : 0] dina
  .douta(data_o_5)  // output wire [11 : 0] douta
);
blk_mem_gen_6 ram_6 (
  .clka(clk_vga),    // input wire clka
  .ena(1),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(data_addr),  // input wire [13 : 0] addra
  .dina(12'b0),    // input wire [11 : 0] dina
  .douta(data_o_6)  // output wire [11 : 0] douta
);
blk_mem_gen_7 ram_7 (
  .clka(clk_vga),    // input wire clka
  .ena(1),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(data_addr),  // input wire [13 : 0] addra
  .dina(12'b0),    // input wire [11 : 0] dina
  .douta(data_o_7)  // output wire [11 : 0] douta
);
blk_mem_gen_8 ram_8 (
  .clka(clk_vga),    // input wire clka
  .ena(1),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(data_addr),  // input wire [13 : 0] addra
  .dina(12'b0),    // input wire [11 : 0] dina
  .douta(data_o_8)  // output wire [11 : 0] douta
);
blk_mem_gen_9 ram_9 (
  .clka(clk_vga),    // input wire clka
  .ena(1),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(data_addr),  // input wire [13 : 0] addra
  .dina(12'b0),    // input wire [11 : 0] dina
  .douta(data_o_9)  // output wire [11 : 0] douta
);
blk_mem_gen_sep ram_sep (
  .clka(clk_vga),    // input wire clka
  .ena(1),      // input wire ena
  .wea(0),      // input wire [0 : 0] wea
  .addra(data_addr),  // input wire [13 : 0] addra
  .dina(12'b0),    // input wire [11 : 0] dina
  .douta(data_o_sep)  // output wire [11 : 0] douta
);
always @(*) begin
    case (flag)
        3'b000: begin
            if(flick_clk&&(flick==2'b10))begin
                        data_R_sel=4'b0;
                        data_G_sel=4'b0;
                        data_B_sel=4'b0;
                    end
            else begin
            case (min_i_r[7:4])
                4'b0000: begin
                    data_R_sel=data_o_0[11:8];
                    data_G_sel=data_o_0[7:4];
                    data_B_sel=data_o_0[3:0];
                end
                4'b0001: begin
                    data_R_sel=data_o_1[11:8];
                    data_G_sel=data_o_1[7:4];
                    data_B_sel=data_o_1[3:0];
                end
                4'b0010: begin
                    data_R_sel=data_o_2[11:8];
                    data_G_sel=data_o_2[7:4];
                    data_B_sel=data_o_2[3:0];
                end
                4'b0011: begin
                    data_R_sel=data_o_3[11:8];
                    data_G_sel=data_o_3[7:4];
                    data_B_sel=data_o_3[3:0];
                end
                4'b0100: begin
                    data_R_sel=data_o_4[11:8];
                    data_G_sel=data_o_4[7:4];
                    data_B_sel=data_o_4[3:0];
                end
                4'b0101: begin
                    data_R_sel=data_o_5[11:8];
                    data_G_sel=data_o_5[7:4];
                    data_B_sel=data_o_5[3:0];
                end
                4'b0110: begin
                    data_R_sel=data_o_6[11:8];
                    data_G_sel=data_o_6[7:4];
                    data_B_sel=data_o_6[3:0];
                end
                4'b0111: begin
                    data_R_sel=data_o_7[11:8];
                    data_G_sel=data_o_7[7:4];
                    data_B_sel=data_o_7[3:0];
                end
                4'b1000: begin
                    data_R_sel=data_o_8[11:8];
                    data_G_sel=data_o_8[7:4];
                    data_B_sel=data_o_8[3:0];
                end
                4'b1001: begin
                    data_R_sel=data_o_9[11:8];
                    data_G_sel=data_o_9[7:4];
                    data_B_sel=data_o_9[3:0];
                end
                default: begin
                    data_R_sel=4'b0;
                    data_G_sel=4'b0;
                    data_B_sel=4'b0;
                end
            endcase
            end
        end
        3'b001:begin
            if(flick_clk&&(flick==2'b10))begin
                        data_R_sel=4'b0;
                        data_G_sel=4'b0;
                        data_B_sel=4'b0;
                    end
            else begin
            case (min_i_r[3:0])
                4'b0000: begin
                    data_R_sel=data_o_0[11:8];
                    data_G_sel=data_o_0[7:4];
                    data_B_sel=data_o_0[3:0];
                end
                4'b0001: begin
                    data_R_sel=data_o_1[11:8];
                    data_G_sel=data_o_1[7:4];
                    data_B_sel=data_o_1[3:0];
                end
                4'b0010: begin
                    data_R_sel=data_o_2[11:8];
                    data_G_sel=data_o_2[7:4];
                    data_B_sel=data_o_2[3:0];
                end
                4'b0011: begin
                    data_R_sel=data_o_3[11:8];
                    data_G_sel=data_o_3[7:4];
                    data_B_sel=data_o_3[3:0];
                end
                4'b0100: begin
                    data_R_sel=data_o_4[11:8];
                    data_G_sel=data_o_4[7:4];
                    data_B_sel=data_o_4[3:0];
                end
                4'b0101: begin
                    data_R_sel=data_o_5[11:8];
                    data_G_sel=data_o_5[7:4];
                    data_B_sel=data_o_5[3:0];
                end
                4'b0110: begin
                    data_R_sel=data_o_6[11:8];
                    data_G_sel=data_o_6[7:4];
                    data_B_sel=data_o_6[3:0];
                end
                4'b0111: begin
                    data_R_sel=data_o_7[11:8];
                    data_G_sel=data_o_7[7:4];
                    data_B_sel=data_o_7[3:0];
                end
                4'b1000: begin
                    data_R_sel=data_o_8[11:8];
                    data_G_sel=data_o_8[7:4];
                    data_B_sel=data_o_8[3:0];
                end
                4'b1001: begin
                    data_R_sel=data_o_9[11:8];
                    data_G_sel=data_o_9[7:4];
                    data_B_sel=data_o_9[3:0];
                end
                default: begin
                    data_R_sel=4'b0;
                    data_G_sel=4'b0;
                    data_B_sel=4'b0;
                end
            endcase
            end
        end
        3'b010:begin
            data_R_sel=data_o_sep[11:8];
            data_G_sel=data_o_sep[7:4];
            data_B_sel=data_o_sep[3:0];
        end
        3'b011:begin
            if(flick_clk&&(flick==2'b01))begin
                        data_R_sel=4'b0;
                        data_G_sel=4'b0;
                        data_B_sel=4'b0;
                    end
            else begin
            case (sec_i_r[7:4])
                4'b0000: begin
                    data_R_sel=data_o_0[11:8];
                    data_G_sel=data_o_0[7:4];
                    data_B_sel=data_o_0[3:0];
                end
                4'b0001: begin
                    data_R_sel=data_o_1[11:8];
                    data_G_sel=data_o_1[7:4];
                    data_B_sel=data_o_1[3:0];
                end
                4'b0010: begin
                    data_R_sel=data_o_2[11:8];
                    data_G_sel=data_o_2[7:4];
                    data_B_sel=data_o_2[3:0];
                end
                4'b0011: begin
                    data_R_sel=data_o_3[11:8];
                    data_G_sel=data_o_3[7:4];
                    data_B_sel=data_o_3[3:0];
                end
                4'b0100: begin
                    data_R_sel=data_o_4[11:8];
                    data_G_sel=data_o_4[7:4];
                    data_B_sel=data_o_4[3:0];
                end
                4'b0101: begin
                    data_R_sel=data_o_5[11:8];
                    data_G_sel=data_o_5[7:4];
                    data_B_sel=data_o_5[3:0];
                end
                4'b0110: begin
                    data_R_sel=data_o_6[11:8];
                    data_G_sel=data_o_6[7:4];
                    data_B_sel=data_o_6[3:0];
                end
                4'b0111: begin
                    data_R_sel=data_o_7[11:8];
                    data_G_sel=data_o_7[7:4];
                    data_B_sel=data_o_7[3:0];
                end
                4'b1000: begin
                    data_R_sel=data_o_8[11:8];
                    data_G_sel=data_o_8[7:4];
                    data_B_sel=data_o_8[3:0];
                end
                4'b1001: begin
                    data_R_sel=data_o_9[11:8];
                    data_G_sel=data_o_9[7:4];
                    data_B_sel=data_o_9[3:0];
                end
                default: begin
                    data_R_sel=4'b0;
                    data_G_sel=4'b0;
                    data_B_sel=4'b0;
                end 
            endcase
            end
        end
        3'b100:begin
            if(flick_clk&&(flick==2'b01))begin
                        data_R_sel=4'b0;
                        data_G_sel=4'b0;
                        data_B_sel=4'b0;
                    end
            else begin
            case (sec_i_r[3:0])
                4'b0000: begin
                    data_R_sel=data_o_0[11:8];
                    data_G_sel=data_o_0[7:4];
                    data_B_sel=data_o_0[3:0];
                end
                4'b0001: begin
                    data_R_sel=data_o_1[11:8];
                    data_G_sel=data_o_1[7:4];
                    data_B_sel=data_o_1[3:0];
                end
                4'b0010: begin
                    data_R_sel=data_o_2[11:8];
                    data_G_sel=data_o_2[7:4];
                    data_B_sel=data_o_2[3:0];
                end
                4'b0011: begin
                    data_R_sel=data_o_3[11:8];
                    data_G_sel=data_o_3[7:4];
                    data_B_sel=data_o_3[3:0];
                end
                4'b0100: begin
                    data_R_sel=data_o_4[11:8];
                    data_G_sel=data_o_4[7:4];
                    data_B_sel=data_o_4[3:0];
                end
                4'b0101: begin
                    data_R_sel=data_o_5[11:8];
                    data_G_sel=data_o_5[7:4];
                    data_B_sel=data_o_5[3:0];
                end
                4'b0110: begin
                    data_R_sel=data_o_6[11:8];
                    data_G_sel=data_o_6[7:4];
                    data_B_sel=data_o_6[3:0];
                end
                4'b0111: begin
                    data_R_sel=data_o_7[11:8];
                    data_G_sel=data_o_7[7:4];
                    data_B_sel=data_o_7[3:0];
                end
                4'b1000: begin
                    data_R_sel=data_o_8[11:8];
                    data_G_sel=data_o_8[7:4];
                    data_B_sel=data_o_8[3:0];
                end
                4'b1001: begin
                    data_R_sel=data_o_9[11:8];
                    data_G_sel=data_o_9[7:4];
                    data_B_sel=data_o_9[3:0];
                end
                default: begin
                    data_R_sel=4'b0;
                    data_G_sel=4'b0;
                    data_B_sel=4'b0;
                end 
            endcase
            end
        end
        3'b101:begin
            data_R_sel=data_o_sep[11:8];
            data_G_sel=data_o_sep[7:4];
            data_B_sel=data_o_sep[3:0];
        end
        3'b110:begin
            if(flick_clk&&(flick==2'b00))begin
                        data_R_sel=4'b0;
                        data_G_sel=4'b0;
                        data_B_sel=4'b0;
                    end
            else begin
            case (ms_10_i_r[7:4])
                4'b0000: begin
                    data_R_sel=data_o_0[11:8];
                    data_G_sel=data_o_0[7:4];
                    data_B_sel=data_o_0[3:0];
                end
                4'b0001: begin
                    data_R_sel=data_o_1[11:8];
                    data_G_sel=data_o_1[7:4];
                    data_B_sel=data_o_1[3:0];
                end
                4'b0010: begin
                    data_R_sel=data_o_2[11:8];
                    data_G_sel=data_o_2[7:4];
                    data_B_sel=data_o_2[3:0];
                end
                4'b0011: begin
                    data_R_sel=data_o_3[11:8];
                    data_G_sel=data_o_3[7:4];
                    data_B_sel=data_o_3[3:0];
                end
                4'b0100: begin
                    data_R_sel=data_o_4[11:8];
                    data_G_sel=data_o_4[7:4];
                    data_B_sel=data_o_4[3:0];
                end
                4'b0101: begin
                    data_R_sel=data_o_5[11:8];
                    data_G_sel=data_o_5[7:4];
                    data_B_sel=data_o_5[3:0];
                end
                4'b0110: begin
                    data_R_sel=data_o_6[11:8];
                    data_G_sel=data_o_6[7:4];
                    data_B_sel=data_o_6[3:0];
                end
                4'b0111: begin
                    data_R_sel=data_o_7[11:8];
                    data_G_sel=data_o_7[7:4];
                    data_B_sel=data_o_7[3:0];
                end
                4'b1000: begin
                    data_R_sel=data_o_8[11:8];
                    data_G_sel=data_o_8[7:4];
                    data_B_sel=data_o_8[3:0];
                end
                4'b1001: begin
                    data_R_sel=data_o_9[11:8];
                    data_G_sel=data_o_9[7:4];
                    data_B_sel=data_o_9[3:0];
                end
                default: begin
                    data_R_sel=4'b0;
                    data_G_sel=4'b0;
                    data_B_sel=4'b0;
                end 
            endcase
                    end
        end
        3'b111:begin
            if(flick_clk&&(flick==2'b00))begin
                        data_R_sel=4'b0;
                        data_G_sel=4'b0;
                        data_B_sel=4'b0;
                    end
            else begin
            case (ms_10_i_r[3:0])
                4'b0000: begin
                    data_R_sel=data_o_0[11:8];
                    data_G_sel=data_o_0[7:4];
                    data_B_sel=data_o_0[3:0];
                end
                4'b0001: begin
                    data_R_sel=data_o_1[11:8];
                    data_G_sel=data_o_1[7:4];
                    data_B_sel=data_o_1[3:0];
                end
                4'b0010: begin
                    data_R_sel=data_o_2[11:8];
                    data_G_sel=data_o_2[7:4];
                    data_B_sel=data_o_2[3:0];
                end
                4'b0011: begin
                    data_R_sel=data_o_3[11:8];
                    data_G_sel=data_o_3[7:4];
                    data_B_sel=data_o_3[3:0];
                end
                4'b0100: begin
                    data_R_sel=data_o_4[11:8];
                    data_G_sel=data_o_4[7:4];
                    data_B_sel=data_o_4[3:0];
                end
                4'b0101: begin
                    data_R_sel=data_o_5[11:8];
                    data_G_sel=data_o_5[7:4];
                    data_B_sel=data_o_5[3:0];
                end
                4'b0110: begin
                    data_R_sel=data_o_6[11:8];
                    data_G_sel=data_o_6[7:4];
                    data_B_sel=data_o_6[3:0];
                end
                4'b0111: begin
                    data_R_sel=data_o_7[11:8];
                    data_G_sel=data_o_7[7:4];
                    data_B_sel=data_o_7[3:0];
                end
                4'b1000: begin
                    data_R_sel=data_o_8[11:8];
                    data_G_sel=data_o_8[7:4];
                    data_B_sel=data_o_8[3:0];
                end
                4'b1001: begin
                    data_R_sel=data_o_9[11:8];
                    data_G_sel=data_o_9[7:4];
                    data_B_sel=data_o_9[3:0];
                end
                default: begin
                    data_R_sel=4'b0;
                    data_G_sel=4'b0;
                    data_B_sel=4'b0;
                end 
            endcase
            end
        end
        default: begin
            data_R_sel=data_o_sep[11:8];
            data_G_sel=data_o_sep[7:4];
            data_B_sel=data_o_sep[3:0];
        end
    endcase
end
always @(posedge clk_vga) begin
    if(data_en)begin
        data_R<=data_R_sel;
        data_G<=data_G_sel;
        data_B<=data_B_sel;
    end
    else begin
        data_R<=4'b0;
        data_G<=4'b0;
        data_B<=4'b0;
    end
    vga_display_o<={h_sync,v_sync,data_R,data_G,data_B};
end
endmodule