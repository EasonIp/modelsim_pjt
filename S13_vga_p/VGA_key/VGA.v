module VGA(clk,rst_n,flag,hs,vs,qa,qb,addra,addrb,rgb);

	input clk,rst_n;
	input flag;
	input [7:0] qa;
	input [7:0] qb;
	
	output reg [15:0] addra;
	output reg [15:0] addrb;
	output reg hs,vs;//列，行使能信号
	output reg [7:0] rgb;
	
	parameter	hv_all = 1648,
					hv_a = 176,
					hv_b = 176,
					hv_c = 1280,
					hv_d = 16;
					
	parameter 	vv_all = 800,
					vv_a = 3,
					vv_b = 28,
					vv_c = 768,
					vv_d = 1;
	reg [9:0] count;

	always @ (posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				begin
					count <= 10'd0;
				end
			else
				begin
					if(flag == 1'b1)
						begin
							count <= count + 1'b1;
						end
					else
						begin
							count <= count;
						end
				end
		end
	
	reg [10:0] cnt_h;//列计数
	//列计数逻辑
	always @ (posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				cnt_h <= 0;
			else if(cnt_h == (hv_all - 1))//列计数
				cnt_h <= 0;
			else
				cnt_h <= cnt_h + 1'd1;
		end
	//列使能信号逻辑
	always @ (posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				hs <= 1'd1;
			else if(cnt_h < hv_a)
				hs <= 1'd0;
			else 
				hs <= 1'd1;
		end
	
	reg [10:0] cnt_v;//行计数
	//行计数逻辑
	always @ (posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				cnt_v <= 0;
			else if(cnt_h == (hv_all-1))
				cnt_v <= cnt_v + 1'd1;
			else if(cnt_v == (vv_all-1))//行计数
				cnt_v <= 0;
		end
	//行使能信号逻辑	
	always @ (posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				vs <= 1;
			else if(cnt_v < vv_a)
				vs <= 0;
			else
				vs <= 1;
		end	
		
	always @ (posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				begin
					addra <= 16'd0;
					addrb <= 16'd25500;
					rgb <= 8'b000_000_00;
				end
			else
				begin
					if((count%2) == 1'b1)
						begin
							if(((cnt_h >= hv_a + hv_b)&&(cnt_h < hv_a + hv_b + hv_c))&&((cnt_v >= vv_a + vv_b)&&(cnt_v < vv_a + vv_b + vv_c)))
								begin
									if(addrb < 43999)
										begin
											rgb <= qb;
											addrb <= ((cnt_h - (hv_a+hv_b))/8 + (cnt_v - (vv_a+vv_b))/8*(hv_c/8) + 25500);
										end
									else
										begin
											addrb <= 16'd25500;
											rgb <= 8'b000_000_00;
										end
								end
							else
								begin
									rgb <= 8'b000_000_00;
								end
						end
					else
						begin
							if(((cnt_h >= hv_a + hv_b)&&(cnt_h < hv_a + hv_b + hv_c))&&((cnt_v >= vv_a + vv_b)&&(cnt_v < vv_a + vv_b + vv_c)))
								begin
									if(((cnt_h>=907)&&(cnt_h<1077))&&((cnt_v>=340)&&(cnt_v<490))) // hua170_150 1366 83.58MHz
										begin
											if(addra < 25499)
												begin
													rgb <= qa;
													addra <= addra + 1'd1;
												end
											else
												begin
													addra <= 16'd0;
													rgb <= 8'b000_000_00;
												end
										end
									else
										begin
											rgb <= 8'b000_000_00;
										end
								end
							else
								begin
									rgb <= 8'b000_000_00;
								end
						end
				end
		end

endmodule 