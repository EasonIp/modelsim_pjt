`timescale 1ns/1ns
module light_tb;
    reg CLK,RST;
    wire [1:0] E_WEST,S_NORTH;
    
    transp_light test(.e_west(E_WEST),.s_north(S_NORTH),.clk(CLK)
                      ,.rst(RST));
    always #5 CLK=~CLK;   
    initial
    begin
        $monitor($time,"E_WEST=%b,S_NORTH=%b,CLK=%b",E_WEST
                 ,S_NORTH,CLK);
    end
    initial
    begin
        RST=0;CLK=0;
        #10 RST=1;
    end
endmodule