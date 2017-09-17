
`timescale 1ns/1ps
`define clk_period 20  //`clk_period
module tb_adder_8bits (); /* this is automatically generated */

	logic rst_n;
	// logic srst;
	logic clk;
	logic [7:0] din_1;
	logic       cin;
	logic [7:0] dout;
	logic [7:0] din_2;
	logic       cout;

	adder_8bits inst_adder_8bits (
		.din_1(din_1), 
		.clk(clk), 
	.cin(cin), 
	.dout(dout), 
	.din_2(din_2), 
	.cout(cout));
	// clock
	initial begin
		clk = 0;
		forever #(`clk_period/2) clk = ~clk;
	end

	// reset
	initial begin
		rst_n = 0;

		#(`clk_period)
		rst_n = 1;
		din_1 = 0;
		din_2 = 10;
		cin = 0;
		repeat (50) @(posedge clk)
		begin
			din_1++;
			din_2++;
		end

		repeat (1) @(posedge clk);
	end

	// (*NOTE*) replace reset, clock, others



	// initial begin
	// 	// do something

	// 	repeat(10)@(posedge clk);
	// 	$finish;
	// end

	// // dump wave
	// initial begin
//        $fsdbDumpfile("tb_adder_8bits.fsdb");
//        $fsdbDumpvars(0, "tb_adder_8bits", "+mda");
	// end

endmodule
