module gray
(
    input clk,
    input rst_n,
    input [7:0] data_in,
    output reg [31:0] data_out,
    output reg clk1x_en
);

reg [1:0] cnt;
reg [31:0] shift_reg;

always @ (posedge clk,negedge rst_n)
begin
    if(!rst_n)
        cnt <= 2'b0;
     else
        cnt <= cnt +1'b1;
end 

always @ (posedge clk,negedge rst_n)
begin
    if(!rst_n)
        clk1x_en <= 1'b0;
    else if(cnt ==2'b01)
        clk1x_en <= 1'b1;
    else
        clk1x_en <= 1'b0;
end

always @ (posedge clk,negedge rst_n)
begin
    if(!rst_n)
        shift_reg <= 32'b0;
    else
        shift_reg <= {shift_reg[23:0],data_in};
end

always @ (posedge clk,negedge rst_n)
begin
    if(!rst_n)
        data_out<= 32'b0;
    else if(clk1x_en==1'b1)//仅在clk1x_en为1时才将shift_reg的值赋给data_out
        data_out<=shift_reg;
end 

endmodule 