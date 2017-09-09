`include "cal_head.v"

module cal_cpu(clk, rst_n, cpu_data_in, acc_int, arb_res, cpu_data_out, cpu_addr_out, cpu_write, cpu_req);
	
	input clk, rst_n;
	input [7:0] cpu_data_in;
	input acc_int, arb_res;
	output reg [7:0] cpu_data_out;
	output reg [15:0] cpu_addr_out;
	output reg cpu_write, cpu_req;
	
	reg [3:0] state;
	
	localparam
		s0 = 4'd0,
		s1 = 4'd1,
		s2 = 4'd2,
		s3 = 4'd3,
		s4 = 4'd4,
		s5 = 4'd5,
		s6 = 4'd6,
		s7 = 4'd7,
		s8 = 4'd8;
		
	always @ (posedge clk)
	begin	
		if(!rst_n)
			begin
				cpu_data_out <= 0;
				cpu_addr_out <= 0;
				cpu_write <= 0;
				cpu_req <= 0;
				state <= s0;
			end
		else 
			case(state)
				s0 :	if(arb_res != `ARB_CPU)
							state <= s0;
						else 
							state <= s1;
				
				s1 :	begin
							cpu_addr_out <= `ASSH;
							cpu_data_out <= `SOURCE_H;
							cpu_write <= 1;
							state <= s2;
						end
				
				s2 :	begin
							cpu_addr_out <= `ASSL;
							cpu_data_out <= `SOURCE_L;
							cpu_write <= 1;
							state <= s3;
						end
					
				s3 :	begin
							cpu_addr_out <= `ASTH;
							cpu_data_out <= `TARGET_H;
							cpu_write <= 1;
							state <= s4;
						end
						
				s4 :	begin
							cpu_addr_out <= `ASTL;
							cpu_data_out <= `TARGET_L;
							cpu_write <= 1;
							state <= s5;
						end
						
				s5 :	begin
							cpu_addr_out <= `S_REG;
							cpu_data_out <= 8'b1000_0000;
							cpu_write <= 1;
							state <= s6;
						end
						
				s6 :	begin
							cpu_write <= 0;
							cpu_req <= 0;
							state <= s7;
						end
						
				s7 :	if(!acc_int)
							state <= s7;
						else 
							state <= s8;
							
				s8 :	state <= s8;
			endcase
	end
	
endmodule
