module rgb1 (clk,rst_n,rgb,flag,q);

	input      clk;
	input      rst_n;
	input      flag;
	input   [7:0] q;
	
	output  reg [7:0]  rgb;
always @(posedge clk,negedge rst_n)
   if(rst_n==0)
	rgb<=8'b000_000_01;
	else  if(flag==1)
	     rgb<=q;
		  else
		  rgb<=8'b000_000_01;
	endmodule
	