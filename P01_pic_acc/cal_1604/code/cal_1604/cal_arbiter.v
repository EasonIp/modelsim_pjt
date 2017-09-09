`include "cal_head.v"

module cal_arbiter(clk, rst_n, cpu_req, acc_req, arb_res);
	
	input clk, rst_n;
	input cpu_req, acc_req;
	output reg arb_res;

	reg state;
	
	localparam s0 = 1'b0;
	localparam s1 = 1'b1;
	
	always @ (posedge clk)
	begin
		if(!rst_n)
			begin
				arb_res <= `ARB_CPU;
				state <= s0;
			end
		else 
			case(state)
				s0 :	if(acc_req && !cpu_req)
							begin
								arb_res <= `ARB_ACC;
								state <= s1;
							end
						else 
							state <= s0;
							
				s1 :	if(!acc_req && cpu_req)
							begin
								arb_res <= `ARB_CPU;
								state <= s0;
							end
						else 
							state <= s1;
			endcase
	end

endmodule
