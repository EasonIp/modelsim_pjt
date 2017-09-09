module cal_mem(clk, rst_n, mem_data_in, mem_addr_in, mem_write, mem_data_out);
	
	input clk, rst_n;
	input [7:0] mem_data_in;
	input [15:0] mem_addr_in;
	input mem_write;
	output reg [7:0] mem_data_out;
	
	reg [7:0] memory [32767:0];
	
	always @ (posedge clk)
	begin
		if(mem_write)
			memory[mem_addr_in[14:0]] <= mem_data_in;
		else 
			mem_data_out <= memory[mem_addr_in[14:0]];
	end
	
endmodule
