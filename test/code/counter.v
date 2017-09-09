module counter (clk,rst_n,cnt);
	input clk;    // 50 MHz Clock
	input rst_n; // Asynchronous reset active low
	output reg [7:0] cnt;

parameter NUM_cnt= 256-1;

always @ (posedge clk or negedge rst_n)
	begin : proc_
	if(~rst_n)
			begin
		 		cnt <= 8'b00000000;
			end
	 else
		 	begin
				if(cnt < NUM_cnt)
				begin
					cnt <= cnt +1 ;
				end
				else
					begin
					cnt <= 8'b00000000;
					end
			end
end



// always @ (posedge clk or negedge rst_n)
// 	begin : proc_
// 	if(~rst_n)
// 			begin
// 		 		cnt <= 8'b00000000;
// 			end
// 	 else
// 		 	begin
// 				if(cnt == NUM_cnt)
// 				begin
// 					cnt <= 8'b00000000;
// 				end
// 				else
// 					begin
// 					cnt <= cnt +1 ;
// 					end
// 			end
// end

// always @ (posedge clk or negedge rst_n)
// 	begin : proc_
// 	if(~rst_n)
// 			begin
// 		 		cnt <= 8'b00000000;
// 			end
// 	 else
// 		 	begin
// 				if(cnt == 8'b11111111)
// 				begin
// 					cnt <= 8'b00000000;
// 				end
// 				else
// 					begin
// 					cnt <= cnt +1 ;
// 					end
// 			end
// end

endmodule