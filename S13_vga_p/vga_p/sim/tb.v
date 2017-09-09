`timescale 1ns/1ps

module  tb;

reg  clk;
reg  rst_n;

wire hs;
wire vs;
wire [7:0] rgb;

initial begin

clk=1;
rst_n=0;
#200.1
rst_n=1;
end
always #10 clk=~clk;
top t_inst(
		.clk(clk),
		.rst_n(rst_n),
		.hs(hs),
		.vs(vs),
		.rgb(rgb)
);
endmodule