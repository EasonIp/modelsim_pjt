
`timescale 1ns/1ps

`define clock_period 20  //`clock_period
module tb_addr64_4stage (); /* this is automatically generated */

	logic rst_n;
	//logic srst;
	logic clk;
// (*NOTE*) replace reset, clock, others

	parameter ADD_WIDTH = 5'd16;

	logic [63 : 0] x;
	logic [63 : 0] y;
	logic [64 : 0] sum;

	addr64_4stage #(
	.ADD_WIDTH(ADD_WIDTH)) inst_addr64_4stage (
	.clk(clk), 
	.rst_n(rst_n), 
	.x(x), 
	.y(y), 
	.sum(sum)
	);
	// clock
	initial begin
		clk = 0;
		forever #(`clock_period/2) clk = ~clk;
	end

	// reset
	initial begin
		rst_n = 0;
		x= 64'd0;
		y= 64'd0;
		#(`clock_period*2) 
		rst_n = 1;
		repeat(20)@(posedge clk) begin 
			x=x +1;y=y+1;
		end
	end

	

	// initial begin
	// 	// do something

	// 	repeat(`clock_period*2)@(posedge clk);
	// 	$finish;
	// end

	// // dump wave
	// initial begin
 //        $fsdbDumpfile("tb_addr64_4stage.fsdb");
 //        $fsdbDumpvars(0, "tb_addr64_4stage", "+mda");
	// end

endmodule
