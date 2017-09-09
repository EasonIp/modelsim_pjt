module top_vga_disp (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	
	output[7:0] vga_r,
	output[7:0] vga_g,
	output[7:0] vga_b,

	output vga_hsy,vga_vsy,
	output vga_clk,
	output adv7123_blank_n,
	output adv7123_sync_n
	
);
	wire clk_40m;

	vga_pll inst_vga_pll (
		.areset(!rst_n),
		.inclk0(clk), 
		.c0(clk_40m)
		);
	vga_control inst_vga_control (
			.clk_40m         (clk_40m),
			.rst_n           (rst_n),
			.vga_r           (vga_r),
			.vga_g           (vga_g),
			.vga_b           (vga_b),
			.vga_hsy         (vga_hsy),
			.vga_vsy         (vga_vsy),
			.vga_clk         (vga_clk),
			.adv7123_blank_n (adv7123_blank_n),
			.adv7123_sync_n  (adv7123_sync_n)
		);



endmodule