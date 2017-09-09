module  top (clk,rst_n,hs,vs,rgb);
input   clk;
input   rst_n;

output  hs;
output  vs;
output  [7:0] rgb;
wire  a;
wire [15:0] addr;
wire  flag;
wire  [7:0] b;
vga  v_inst(
		.clk(a),
		.rst_n(rst_n),
		.hs(hs),
		.vs(vs),
		.addr(addr),
		.flag(flag)
		);
rgb1 r_inst(
		.clk(a),
		.rst_n(rst_n),
		.rgb(rgb),
		.flag(flag),
		.q(b)
        );
my_pll p_inst(
	.inclk0(clk),
	.c0(a)
	);
my_rom rom_inst (
	.address(addr),
	.clock(a),
	.q(b)
	);
endmodule