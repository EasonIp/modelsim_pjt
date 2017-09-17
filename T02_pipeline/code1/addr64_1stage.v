module	addr64_1stage(
input	clk, rst_n,
input	[63 : 0]	x, y,
// output reg	[64 : 0]	sum
output [64 : 0]	sum
);

 

reg  [63:0]x_r,y_r;



parameter	ADD_WIDTH = 5'd16;

assign sum = x_r + y_r;


always @(posedge clk or negedge rst_n)	
begin
	if(!rst_n)	begin
		x_r <= 1'b0;
		y_r <= 1'b0;
	end
	else
	begin
		x_r <= x;
		y_r <= y;
		// sum <= x_r + y_r;
	end	//rst_n else
end	//always

endmodule