`timescale 1ns/1ps

module pulse_tb;

	reg clk, rst_n;

	wire pio_led;

	pulse #(.CNT1(4), .CNT3(4)) dut(.clk(clk), .rst_n(rst_n), .pio_led(pio_led));
	
	initial begin
		clk = 1;
		rst_n = 0;
		#200.1	rst_n = 1;

		#100_000		$stop;
	
	
	end

	always #10 clk = ~clk;


endmodule

