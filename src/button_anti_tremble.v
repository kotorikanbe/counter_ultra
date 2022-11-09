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