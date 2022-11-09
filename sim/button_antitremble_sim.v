`timescale 1ns/1ps
module button_anti_tremble_sim();
reg clk=1'b0;
reg button=1'b0;
wire out;
initial begin
    while(1)begin
        #5
        clk=~clk;
    end
end
initial begin
    #1
    button=1'b1;
    #1
    button=1'b0;
    #1
    button=1'b1;
    #1
    button=1'b0;
    #1
    button=1'b1;
    #1
    button=1'b0;
    #1
    button=1'b1;
    #50
    button=1'b0;
    #50
    button=1'b1;
    #1
    button=1'b0;
    #1
    button=1'b1;
    #1
    button=1'b0;
    #1
    button=1'b1;
    #1
    button=1'b0;
    #1
    button=1'b1;
    #50
    button=1'b0;
     #50
    button=1'b1;
    #1
    button=1'b0;
    #1
    button=1'b1;
    #1
    button=1'b0;
    #1
    button=1'b1;
    #1
    button=1'b0;
    #1
    button=1'b1;
    #50
    button=1'b0;
    #100
    button=1'b1;
end
button_anti_tremble test(
    .button_i(button),
    .button_o(out),
    .clk_core(clk)
);
endmodule
