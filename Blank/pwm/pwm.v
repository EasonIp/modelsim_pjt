module pwm(clk, rst_n, pio_led);

	input clk;
	input rst_n;
	
	output [3:0] pio_led;

	parameter US = 49;
	parameter MS = 999;
	parameter  S = 999;
	
	reg [19:0] count1, count2, count3;
	reg flag1, flag2, flag3;
	reg pwm;
	reg s;
	
	always @ (posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			begin
				count1 <= 0;
				flag1 <= 0;
			end
		else if (count1 == US)
			begin
				count1 <= 0;
				flag1 <= 1;
			end
		else
			begin
				count1 <= count1 + 1;
				flag1 <= 0;
			end
	end
	
	always @ (posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			begin
				count2 <= 0;
				flag2 <= 0;
			end
		else if (count2 == MS && flag1)
			begin
				count2 <= 0;
				flag2 <= 1;
			end
		else if (flag1)
			begin
				count2 <= count2 + 1;
				flag2 <= 0;
			end
		else
			flag2 <= 0;
	end
	
	always @ (posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			begin
				count3 <= 0;
				flag3 <= 0;
			end
		else if (count3 == S && flag2)
			begin
				count3 <= 0;
				flag3 <= 1;
			end
		else if (flag2)
			begin
				count3 <= count3 + 1;
				flag3 <= 0;
			end
		else
			flag3 <= 0;
	end
	
	always @ (posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			begin
				pwm <= 0;
			end
		else if (count2 < count3)
			pwm <= 0;
		else
			pwm <= 1;
	end
	
	always @ (posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			begin
				s <= 0;
			end
		else if (flag3 == 1)
			s <= ~s;
		else
			s <= s;
	end
	
	assign pio_led = s ? {4{pwm}}: ~{4{pwm}};
		
endmodule 

