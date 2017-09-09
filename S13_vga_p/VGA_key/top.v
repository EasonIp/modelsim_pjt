module top(clk,rst_n,key,hs,vs,rgb);

	input clk,rst_n;
	input key;
	
	output hs,vs;
	output [7:0] rgb;
	
	wire [15:0] addra;
	wire [15:0] addrb;
	wire c0;
	wire [7:0] qa;
	wire [7:0] qb;
	wire flag;
	
	my_pll	my_pll_inst (
				.inclk0 (clk),
				.c0 (c0)
				);

	my_rom	my_rom_inst (
				.address_a (addra),
				.address_b (addrb),
				.clock (c0),
				.q_a (qa),
				.q_b (qb)
				);
	
	fitter fitter(
				.clk(c0), 
				.rst_n(rst_n),
				.key(key),
				.flag(flag)
			);
	
	VGA VGA(
				.clk(c0),
				.rst_n(rst_n),
				.flag(flag),
				.qa(qa),
				.qb(qb),
				.hs(hs),
				.vs(vs),
				.rgb(rgb),
				.addra(addra),
				.addrb(addrb)
			);

endmodule 