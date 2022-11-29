////////////////////////////////////////////////////////////////////////////////
//本模块为按钮消抖模块，且为了防止多次跳变，此消抖模块的输出为一个输入clk时钟的周期。//
///////////////////////////////////////////////////////////////////////////////
module button_anti_tremble(
    clk_core,button_i,button_o
);
input clk_core;
input button_i;
output button_o;
reg tmp=1'b0;
reg count=1'b0;
reg button_o=1'b0 ;
reg flag=1'b1;
//消抖原理为两次时钟上升沿若为同一电平信号，则输出该信号，否则输入原来的信号，flag用于当长按时输出在一个周期后也强制跳变为0//
always @(posedge clk_core) begin
    if(!count)begin
        tmp<=button_i;
        count<=~count;
        if(!flag) button_o<=1'b0;
        else ;
    end
    else begin
        if(tmp==button_i&&flag)begin
            button_o<=button_i;
            if(button_i)begin
                flag<=1'b0;
            end
            else ;
        end
        else begin
            button_o<=1'b0;
        end
        count<=~count ;
    end
    if(~button_i)begin
        flag<=1'b1;
    end
    else ;
end
endmodule