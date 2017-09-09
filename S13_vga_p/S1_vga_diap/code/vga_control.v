module vga_control (
	input clk_40m,    // Clock
	input rst_n,  // Asynchronous reset active low


	output[7:0] vga_r,
	output[7:0] vga_g,
	output[7:0] vga_b,
	output vga_clk,
	output adv7123_blank_n,
	output adv7123_sync_n,
	//-----------------------------------------------------------				
	output reg vga_hsy,
	output reg vga_vsy
);
	assign vga_clk = clk_40m;
	wire clk;
	assign clk = clk_40m;
	reg [11:0] xcnt;  //1056
	reg [11:0] ycnt;   //行628

	parameter VGA_HTT = 12'd1056-12'd1;	//Hor Total Time
	parameter VGA_HST = 12'd128;		//Hor Sync  Time
	parameter VGA_HBP = 12'd88;		//Hor Back Porch
	parameter VGA_HVT = 12'd800;	//Hor Valid Time
	parameter VGA_HFP = 12'd40;		//Hor Front Porch

	parameter VGA_VTT = 12'd628-12'd1;	//Ver Total Time
	parameter VGA_VST = 12'd4;		//Ver Sync Time
	parameter VGA_VBP = 12'd23;		//Ver Back Porch
	parameter VGA_VVT = 12'd600;	//Ver Valid Time
	parameter VGA_VFP = 12'd1;		//Ver Front Porch

	//先进行列计数(行扫描)  然后行计数(列扫描)  
	//列计数1055后行才开始计数
	always @(posedge clk or negedge rst_n) 
	begin : proc_x
		if(~rst_n) begin
			xcnt <= 12'b0;
		end else begin
			if(xcnt == 1055) begin
				xcnt <= 12'd0;
				end
			else 
				begin
				xcnt <= xcnt + 1;
				end
		end
	end

	always @(posedge clk or negedge rst_n) 
	begin : proc_2
		if(~rst_n) begin
			ycnt <= 12'b0;
		end else begin
			if(ycnt <= 627) begin
				if(xcnt == 1055) begin
				ycnt <= ycnt + 1;
				end
				else
				ycnt <= ycnt;
			end
			else
				ycnt <= 0;
		end
	end

// 时序划分abcd，并给行列输出值

	always @(posedge clk or negedge rst_n) 
	begin : proc_hsvs
		if(~rst_n) begin
			vga_hsy <= 1;
			vga_vsy <= 1;
		end else begin
			if(xcnt <= 127) begin
				vga_hsy <= 0;
			end else if( (xcnt == 1055) && ycnt == 3) begin
				vga_vsy <= 0;
			end else begin
				vga_hsy <= 1;
				vga_vsy <= 1;
			end
		end
	end



//-----------------------------------------------------------				
reg vga_valid;

always @(posedge clk or negedge rst_n)
	if(!rst_n) vga_valid <= 1'b0;
	else if((xcnt >= (VGA_HST+VGA_HBP)) && (xcnt < (VGA_HST+VGA_HBP+VGA_HVT))
			&& (ycnt >= (VGA_VST+VGA_VBP)) && (ycnt < (VGA_VST+VGA_VBP+VGA_VVT)))
		 vga_valid <= 1'b1;
	else vga_valid <= 1'b0;

assign adv7123_blank_n = vga_valid;
assign adv7123_sync_n = 1'b0;





//显示区域的内容
//行 列同时在c段时显示rgb数据




// 彩条赋值
reg[7:0] vga_rdb;
reg[7:0] vga_gdb;
reg[7:0] vga_bdb;

always @(posedge clk or negedge rst_n)
	if(!rst_n) begin
		vga_rdb <= 8'd0;
		vga_gdb <= 8'd0;
		vga_bdb <= 8'd0;
	end
	else if(xcnt == (VGA_HST+VGA_HBP)) begin								
		vga_rdb <= 8'h0;
		vga_gdb <= 8'h3f;
		vga_bdb <= 8'd0;		
	end
	else if(xcnt == (VGA_HST+VGA_HBP+VGA_HVT-1'b1)) begin					
		vga_rdb <= 8'h0;
		vga_gdb <= 8'h3f;
		vga_bdb <= 8'd0;		
	end
	else if(ycnt == (VGA_VST+VGA_VBP)) begin								
		vga_rdb <= 8'h0;
		vga_gdb <= 8'h3f;
		vga_bdb <= 8'd0;		
	end
	else if(ycnt == (VGA_VST+VGA_VBP+VGA_VVT-1'b1)) begin					
		vga_rdb <= 8'h0;
		vga_gdb <= 8'h3f;
		vga_bdb <= 8'd0;		
	end
	else begin																
		vga_rdb <= 8'h1f;
		vga_gdb <= 8'd0;
		vga_bdb <= 8'd0;	
	end

//-----------------------------------------------------------				
assign vga_r = vga_valid ? vga_rdb:8'd0;
assign vga_g = vga_valid ? vga_gdb:8'd0;	
assign vga_b = vga_valid ? vga_bdb:8'd0;	


// 纯色赋值
// always @(posedge clk or negedge rst_n)
// begin : proc_disp
// 	if(~rst_n) begin
// 		vga_rgb <= 8'd0;
// 	end else begin
// 			if( (xcnt >=217 && xcnt <=1015) && (ycnt >27 && ycnt < 627) ) begin
// 				vga_rgb<= 8'b111_100_00;
// 			end
// 			else
// 			begin
// 				vga_rgb<= 8'b000_000_00;
// 			end
// 	end
// end





// always @(posedge clk or negedge rst_n)
// begin : proc_disp
// 	if(~rst_n) begin
// 		vga_rgb <= 8'd0;
// 	end else begin
// 			if( (xcnt >=217 && xcnt <=1015) || (ycnt >=27 && ycnt <= 627) ) begin
// 				vga_rgb<= 8'b111_100_00;
// 			end
// 			else
// 			begin
// 				vga_rgb<= 8'b000_000_00;
// 			end
// 	end
// end

endmodule