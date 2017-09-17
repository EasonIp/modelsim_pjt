module adder_8bits(din_1, clk, cin, dout, din_2, cout);
    input [7:0] din_1;
    input clk;
    input cin;
    output [7:0] dout;
    input [7:0] din_2;
    output cout;
	 
	 reg [7:0] dout;
	 reg       cout;
	 
	 always @(posedge clk) begin
		{cout,dout} <= din_1 + din_2 + cin;
	 end

endmodule