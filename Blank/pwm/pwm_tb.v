`timescale 1ns/1ns
module pwm_tb();

	reg clk;
	reg rst_n;
	
	wire [3:0] pio_led;
	
	initial
		begin
			clk = 1;
			rst_n = 0;
			#1000
			rst_n = 1;
		end

	always #10 clk = ~clk;	

	pwm1 
	#(.US(20),
	  .MS(40),
	  .S(40))
	pwm(
	.clk(clk), 
	.rst_n(rst_n), 
	.pio_led(pio_led)
	);

endmodule 