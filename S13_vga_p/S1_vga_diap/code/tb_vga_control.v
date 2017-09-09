
`timescale 1ns/1ps

module tb_vga_control (); /* this is automatically generated */

	reg rst_n;
	reg clk_40m;

	wire [7:0] vga_r;
	wire [7:0] vga_g;
	wire [7:0] vga_b;
	wire  vga_clk;
	wire  adv7123_blank_n;
	wire  adv7123_sync_n;
	//-----------------------------------------------------------				
	wire  vga_hsy;
	wire  vga_vsy;
	// clock
	initial begin
		clk_40m = 0;
		forever #12 clk_40m = ~clk_40m;
	end
		vga_control inst_vga_control (
			.clk_40m         (clk_40m),
			.rst_n           (rst_n),
			.vga_r           (vga_r),
			.vga_g           (vga_g),
			.vga_b           (vga_b),
			.vga_clk         (vga_clk),
			.adv7123_blank_n (adv7123_blank_n),
			.adv7123_sync_n  (adv7123_sync_n),
			.vga_hsy         (vga_hsy),
			.vga_vsy         (vga_vsy)
		);


	// reset
	initial begin
		
		rst_n = 0;
		#20
		rst_n = 1;
		repeat (50000) @(posedge clk_40m);
		$stop;
		
	end

	// (*NOTE*) replace reset, clock, others



endmodule
