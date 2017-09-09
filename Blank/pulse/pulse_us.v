module pulse_us(clk, rst_n, flag);

	input clk, rst_n;

	output reg flag;
	
	reg [31:0] count;
	
	parameter CNT = 49; //1us, 50-1
	
	
	always @ (posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			begin
				flag <= 0;
				count <= 0;
			end
		else
			begin
				if (count < CNT)
					begin
						count <= count + 1;
						flag <= 0;
					end
				else
					begin
						count <= 0;
						flag <= 1;
					end
					
			end
	end

endmodule
