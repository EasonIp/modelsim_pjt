`timescale 1ns/1ps

module pulse_us_tb;

	reg clk, rst_n;

	wire flag;

	pulse_us dut(.clk(clk), .rst_n(rst_n), .flag(flag));
	
	initial begin
		clk = 1;
		rst_n = 0;
		#200.1	rst_n = 1;

		#3000		$stop;
	
	
	end

	always #10 clk = ~clk;


endmodule

