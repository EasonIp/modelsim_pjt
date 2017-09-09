module rom_c(clk,rst_n,addr,flag);

	input    clk;
	input    rst_n;
	input    flag;
	
	output   reg [15:0] addr;
always @(posedge clk,negedge rst_n)
      if(rst_n==0)
	   begin
		 addr<=0;
		 end
		else if(flag==1)
					if(addr<40000-1)
					  addr<=addr+1'b1;
					else
						addr<=1'b0;
				else 
				     addr<=addr;
	endmodule
				