module clk_10k (
	input clk,    // Clock
	
	input rst_n,  // Asynchronous reset active low
	output clk_out
);

reg [31:0]cnt;
parameter cnt_num = 50_000_000 / 10_000 /2 - 1;

always @(posedge clk or negedge rst_n) 
begin : proc_
	if(~rst_n) begin
		cnt <= 0;
	end else begin
		  	if(cnt < cnt_num) begin
		  		cnt <= cnt + 1;
		  	end
		  	else
		  		cnt <= 0;
	end
end

	assign clk_out = (cnt < cnt_num)?1'b0 : 1'b1;
endmodule