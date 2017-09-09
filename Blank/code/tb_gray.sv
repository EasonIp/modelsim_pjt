
`timescale 1ns/1ps
`define  period 20

module tb_gray (); /* this is automatically generated */

	logic clk;
    logic rst_n;
    logic [7:0] data_in;
    logic [31:0] data_out;
    logic clk1x_en;
	// clock
	initial begin
		clk = 0;
		forever #(`period/2) clk = ~clk;
	end

	// reset
	initial begin
		rst_n = 0;
		#(`period*2)
		rst_n = 1;
	end

	gray inst_gray
		(
			.clk      (clk),
			.rst_n    (rst_n),
			.data_in  (data_in),
			.data_out (data_out),
			.clk1x_en (clk1x_en)
		);

	initial begin
		data_in = 8'd0;
		forever #(`period) data_in = data_in +1;
	end

	// // dump wave
	// initial begin
 //        $fsdbDumpfile("tb_gray.fsdb");
 //        $fsdbDumpvars(0, "tb_gray", "+mda");
	// end

endmodule
