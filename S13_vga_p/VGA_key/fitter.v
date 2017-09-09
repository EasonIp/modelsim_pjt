module fitter(clk, rst_n, key, flag);//qian dou dong

	input clk, rst_n;
	input key;
	
	output reg flag;

	`define T 100000

	reg [18:0] cnt;
	reg state;
	
	always @ (posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				begin
					cnt <= 19'd0;
					state <= 0;
					flag <= 1'b0;
				end
			else
				begin
					case(state)
						0:	begin
								if(!key)
									begin
										if(cnt < `T - 1)
											begin
												flag <= 1'b0;
												cnt <= cnt + 1'b1;
												state <= 0;
											end
										else
											begin
												flag <= 1'b0;
												cnt <= cnt;
												state <= 1;
											end
									end
								else
									begin
										cnt <= 0;
										flag <= 1'b0;
										state <= 0;
									end
							end
						1:	begin
								if(!key)
									begin
										state <= 1;
										cnt <= 0;
										flag <= 1'b0;
									end
								else
									begin
										if(cnt < `T - 1)
											begin
												flag <= 1'b0;
												cnt <= cnt + 1'b1;
												state <= 1;
											end
										else
											begin
												flag <= 1'b1;
												state <= 0;
											end
									end
							end
						default:state <= 0;
					endcase
				end
		end

endmodule 