`timescale 1ns/1ns

module latency_tb;

	reg clk, rst_n;
	reg	edata;
	wire data2;
	wire data1;
	
	latency	latency(
		.clk(clk), 
		.rst_n(rst_n), 
		.edata(edata), 
		.data1(data1), 
		.data2(data2)
	);
	
	initial
	begin
		clk=1;
		rst_n=0;
		edata=0;
		#200.1 
		rst_n=1;
		edata=1;
		#1000 $stop;
	end
	
	always # 10 clk=~clk;
	
endmodule
	