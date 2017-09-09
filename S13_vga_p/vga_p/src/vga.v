module vga (clk,rst_n,hs,vs,flag,addr);

	input  		clk;
	input       rst_n;
	
	output  	reg	vs;
	output   reg  hs;
	output   reg  flag;    
	output   reg  [15:0] addr;
	reg  [10:0] h_cnt;
	reg  [10:0] v_cnt;
	parameter  hs_e=800,
	           hs_d=16,
				  hs_c=640,
				  hs_b=48,
				  hs_a=96;
	parameter  vs_e=525,
	           vs_d=10,
				  vs_c=480,
				  vs_b=33,
				  vs_a=2;
				  //lie
always @(posedge clk,negedge rst_n)
   if(rst_n==0)
	  h_cnt<=0;
	else if(h_cnt<hs_e-1)
	     h_cnt<=h_cnt+1'b1;
		  else
		   h_cnt<=1'b0;
			//hang
always @(posedge clk,negedge rst_n)
   if(rst_n==0)
	  v_cnt<=0;
	else if(v_cnt==vs_e-1)
	     v_cnt<=0;
		  else if(h_cnt==hs_e-1)
		       v_cnt<=v_cnt+1'b1;
always @(posedge clk,negedge rst_n)
   if(rst_n==0)
	  hs<=1;
	 else if(h_cnt==hs_a-1)
	         hs<=1;
			else if(h_cnt==0)
			   hs<=0;
always @(posedge clk,negedge rst_n)
   if(rst_n==0)
	  begin
	  vs<=1;
	  end
	 else if(v_cnt==0)
	         vs<=0;
	else if(v_cnt==vs_a)
			   vs<=1;
				
always @(posedge clk,negedge rst_n)
  if(rst_n==0)
	 begin
	 flag<=0;
	 addr<=0;
	 end
else 
	  if((h_cnt>=hs_a+hs_b&&h_cnt<=543)&&(v_cnt>=vs_a+vs_b&&v_cnt<=434))
					if(addr<40000-1)
					begin
					addr<=(h_cnt-hs_a-hs_b)/2+(v_cnt-vs_a-vs_b)/2*200;
					flag<=1;
					end
					else
					  begin
						flag<=0;
						addr<=0;
						end
	       else
				  begin
				  addr<=addr;
				  flag<=0;
				  end
	endmodule
	     
