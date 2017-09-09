module pulse(clk, rst_n, pio_led);

	input clk, rst_n;

	output[3:0] pio_led;
	
	reg [31:0] count1, count2, count3;   //, count_duty
	reg flag1, flag2, flag3, flag4, pwm, flag1_1;
	
//	parameter CNT1 = 49; //1s/1us, 50-1
	parameter CNT1 = 499; //10s/10us, 500-1
	parameter CNT3 = 999; //1000-1
	
	
	always @ (posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			begin
				flag1 <= 0;
				count1 <= 0;
			end
		else
			begin
				if (count1 < CNT1)
					begin
						count1 <= count1 + 1;
						flag1 <= 0;
					end
				else
					begin
						count1 <= 0;
						flag1 <= 1;
					end
			end
	end

	always @ (posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			begin
				count2 <= 0;
				flag2 <= 0;
			end
		else if (flag1)
			begin
				if (count2 < CNT3)
					begin
						count2 <= count2 + 1;
						flag2 <= 0;
					end
				else
					begin
						count2 <= 0;
						flag2 <= 1;
					end
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
		else if (flag2)
			begin
				if (count3 < CNT3)
					begin
						count3 <= count3 + 1;
						flag3 <= 0;
					end
				else
					begin
						count3 <= 0;
						flag3 <= 1;
					end
			end
		else
			flag3 <= 0;
	end

	always @ (posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			flag4 <= 1;
		else if (flag1)
			begin
				if (count2 < count3)
					flag4 <= 1;
				else
					flag4 <= 0;
			end
	end

	always @ (posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			begin
				pwm <= 0;
			end
		else if (flag3)
			pwm <= ~pwm;
		else
			pwm <= pwm;
	end
	
	assign pio_led = (flag4 ? {{2{pwm}}, {2{~pwm}}} : {{2{~pwm}}, {2{pwm}}}) & {4{flag1_1}};
	
	always @ (posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			begin
				flag1_1 <= 0;
			end
		else
			flag1_1 <= flag1;
	end

	
endmodule
