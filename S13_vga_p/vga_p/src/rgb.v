module rgb (clk,rst_n,rgb,flag);

	input      clk;
	input      rst_n;
	input      flag;
	output  reg [7:0]  rgb;
	wire   [7:0] q;
always (posedge clk,negedge rst_n)
   if(rst_n==0)
	rgb<=8'b000_000_01;
	else  if(flag==1)
	     rgb<=q;
		  else
		  rgb<=8'b000_000_01;
	endmodule
	