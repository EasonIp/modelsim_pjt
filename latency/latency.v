module latency(clk, rst_n, edata, data1, data2);

	input clk, rst_n;
	input	edata;
	output reg data2;
	output reg data1;
	
	always @ (posedge clk)
	begin
		if(!rst_n)
			begin
				data1<=0;
				data2<=0;
			end
		else
			begin
				data1<=edata;
				data2<=data1;
			end
	end
endmodule

