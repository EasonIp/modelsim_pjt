`timescale 1ns/1ns
`define clk_period 20

module uart_tx_top_tb;

	reg Clk;
	reg Rst_n;
	wire key;
	reg [2:0]baud_set;
	wire led;
	reg press;
	wire Rs232_Tx;
	
	uart_tx_top uart_tx_top0(Clk,Rst_n,Rs232_Tx,key,led);
	key_model key_model(press,key);
	
	initial Clk = 1;
	always#(`clk_period/2)Clk = ~Clk;
	
	initial begin
		Rst_n = 1'b0;
		press = 0;
		#(`clk_period*20 +1);
		Rst_n = 1'b1;
		#(`clk_period*20 +1);
		press = 1;
		#(`clk_period*20 +1);
		press = 0;
		
		wait(uart_tx_top0.Tx_Done &(uart_tx_top0.cnt == 3'd5));
		#(`clk_period*200 +1);
		$stop;	
	end

endmodule
