module clk_10k_2 (
	input clk,    // Clock
	
	input rst_n,  // Asynchronous reset active low
	output reg clk_out
);

reg [31:0]cnt;
parameter cnt_num = 50_000_000 / 10_000 /2 - 1;

always @(posedge clk or negedge rst_n) 
begin : proc_
	if(~rst_n) begin
		clk_out <= 0;
	end else begin
		  	if(cnt < cnt_num) begin
		  		cnt <= cnt + 1;
		  	end
		  	else
		  		cnt <= 0;
		  		clk_out <= ~clk_out;
	end
end

endmodule