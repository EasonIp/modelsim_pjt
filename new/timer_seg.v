module timer_seg (
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst_n,  // Asynchronous reset active low
	
);


		//一秒定时
	reg [24:0]time_1s;
	always @(posedge clk or negedge rst_n)
		begin
				if(!rst_n) 
					time_1s<=25'b0;
				else 
					if (time_1s==25'd24_999_999) 
						time_1s<=25'b0;//1s时间到后重新计时
					else 
						time_1s<=time_1s+1'b1;
		end

	wire time_done=(time_1s==25'd24_999_999);//1s时间到时的标志位



	//0-9999计数   16'h9999  不是用围巾织转BCD实现的

	//
	reg [15:0] cnt;
	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n) 
			cnt<=16'b0;
		else if(time_done)
				begin
					if (cnt[15:0]==16'h9999) 
					 cnt<=16'b0;//计满10000，回归到0
					else if(cnt[11:0]==12'h999) 
							 begin 
							    cnt[11:0]<=12'b0;//计满999，显示为1000
							 	cnt[15:12]<=cnt[15:12]+1'b1;
							 end
					else if(cnt[7:0]==8'h99)
					 		begin
						        cnt[7:0]<=8'h0;//计满99，显示为*100
						 		cnt[15:8]<=cnt[15:8]+1'b1;
					 		end
					else if(cnt[3:0]==4'h9)
				 			begin
				        		cnt[3:0]<='h0;//计满9，显示为*10
				 				cnt[15:4]<=cnt[15:4]+1'b1;  
				 			end
					else  cnt<=cnt+1'b1;//1s时间到，则计一次数
			 	end
	end

endmodule

