`timescale 1ns/1ps

module tb();

	reg clk,rst_n;
	
	wire hs,vs;
	wire [7:0] rgb;

	initial
		begin
			clk = 0;
			rst_n = 0;
			#1000.1
			rst_n = 1;
		end

	always #10 clk = ~clk;
		
top top(
		.clk(clk),
		.rst_n(rst_n),
		.hs(hs),
		.vs(vs),
		.rgb(rgb)
		);

endmodule 