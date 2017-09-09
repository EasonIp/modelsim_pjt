`timescale   1ns/1ps
module tb_B2BCD_2 ();

	reg [7:0]binary_in;    // Clock
	wire [3:0]hundreds;
	wire [3:0]tens;
	wire [3:0]ones;

	B2BCD inst_B2BCD
		(
			.binary_in (binary_in),
			.hundreds  (hundreds),
			.tens      (tens),
			.ones      (ones)
		);


	initial
	begin
		binary_in = 8'b0000_0000;
	end

	always #40 binary_in = binary_in + 1;
	
	

endmodule