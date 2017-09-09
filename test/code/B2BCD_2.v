module B2BCD_2 (
	input [7:0]binary_in,    // Clock
	output reg [3:0]hundreds,
	output reg [3:0]tens,
	output reg [3:0]ones
);

	always @(*) 
		begin : proc_
			hundreds = binary_in / 100;
			tens = (binary_in % 100 ) /10;
			ones = binary_in % 10;
		end
endmodule