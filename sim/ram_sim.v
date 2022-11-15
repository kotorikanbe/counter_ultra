`timescale 1ns/1ns
module ram_sim();
reg clka=1'b0;
reg wea=1'b0;
reg ena=1'b1;
reg [13:0]addra=0;
reg [11:0]dina=0;
wire [11:0]douta;
initial begin
    while (1) begin
        #5 clka=~clka;
    end
end
initial begin
    while(1)begin
        #10 addra=addra+1;
    end
end
blk_mem_gen_0 ram_0 (
  .clka(clka),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [13 : 0] addra
  .dina(dina),    // input wire [11 : 0] dina
  .douta(douta)  // output wire [11 : 0] douta
);
endmodule
