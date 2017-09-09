module vga_ctrl(
		clk_25_175m,clk_40m,rst_n,
		vga_r,vga_g,vga_b,
		vga_hsy,vga_vsy,vga_clk,
		adv7123_blank_n,adv7123_sync_n
	);

input clk_25_175m;
input clk_40m;
input rst_n;
//-----------------------------------------------------------				
output[7:0] vga_r;
output[7:0] vga_g;
output[7:0] vga_b;
output vga_clk;
output reg adv7123_blank_n;
output adv7123_sync_n;
//-----------------------------------------------------------				
output reg vga_hsy,vga_vsy;

//-----------------------------------------------------------				
wire clk;
assign vga_clk = clk;

//-----------------------------------------------------------				
 `define VGA_640_480
//`define VGA_800_600

//-----------------------------------------------------------				
`ifdef VGA_640_480															
	assign clk = clk_25_175m;
		
	// parameter Hs_t = 12'd800-12'd1;	//Hor Total Time
	// parameter Hs_a = 12'd96;		//Hor Sync  Time
	// parameter Hs_b = 12'd48;//+12'd16;		//Hor Back Porch
	// parameter Hs_c = 12'd640;	//Hor Valid Time
	// parameter Hs_d = 12'd16;		//Hor Front Porch

	// parameter Vs_t = 12'd525-12'd1;	//Ver Total Time
	// parameter Vs_a = 12'd2;		//Ver Sync Time
	// parameter Vs_b = 12'd33;//-12'd4;		//Ver Back Porch
	// parameter Vs_c = 12'd480;	//Ver Valid Time
	// parameter Vs_d = 12'd10;		//Ver Front Porch

	parameter Hs_t = 800;
  	parameter Hs_b = 144;
  	parameter Hs_c = 640;
  	parameter Hs_d = 16;
	
  	parameter Vs_t = 525;
  	parameter Vs_b = 34;
  	parameter Vs_c = 480;
  	parameter Vs_d = 11;
	
  	parameter Hs_a = 96;
  	parameter Vs_a = 2;
`endif

`ifdef VGA_800_600															
	//VGA Timing 800*600 & 50MHz & 72Hz
	assign clk = clk_40m;

	parameter Hs_t = 12'd1056-12'd1;	//Hor Total Time
	parameter Hs_a = 12'd128;		//Hor Sync  Time  a
	parameter Hs_b = 12'd88;		//Hor Back Porch  b
	parameter Hs_c = 12'd800;	//Hor Valid Time  c
	parameter Hs_d = 12'd40;		//Hor Front Porch  d

	parameter Vs_t = 12'd628-12'd1;	//Ver Total Time
	parameter Vs_a = 12'd4;		//Ver Sync Time
	parameter Vs_b = 12'd23;		//Ver Back Porch
	parameter Vs_c = 12'd600;	//Ver Valid Time
	parameter Vs_d = 12'd1;		//Ver Front Porch
`endif

//-----------------------------------------------------------				
reg[11:0] hx_cnt;
reg[11:0] vy_cnt;
wire cHD,cVD,cDEN,hori_valid,vert_valid;

always @(posedge clk or negedge rst_n) begin : proc_
	if(~rst_n) begin
		hx_cnt<=11'd0;
     	vy_cnt<=10'd0;
	end else begin
		if (hx_cnt==Hs_t-1)
	      begin 
	         hx_cnt<=11'd0;
	         if (vy_cnt==Vs_t-1)
	            vy_cnt<=10'd0;
	         else
	            vy_cnt<=vy_cnt+1;
	      end
	      else
	         hx_cnt<=hx_cnt+1;
		end
end



// always@(negedge clk,posedge rst_n)
// begin
//   if (~rst_n)
//   begin
    
//   end
//     else
//     begin
//       if (hx_cnt==Hs_t-1)
//       begin 
//          hx_cnt<=11'd0;
//          if (vy_cnt==Vs_t-1)
//             vy_cnt<=10'd0;
//          else
//             vy_cnt<=vy_cnt+1;
//       end
//       else
//          hx_cnt<=hx_cnt+1;
//     end
// end

assign cHD = (hx_cnt<Hs_a)?1'b0:1'b1;    
assign cVD = (vy_cnt<Vs_a)?1'b0:1'b1;

assign hori_valid = (hx_cnt<(Hs_t-Hs_d)&& hx_cnt>=Hs_b)?1'b1:1'b0;
assign vert_valid = (vy_cnt<(Vs_t-Vs_d)&& vy_cnt>=Vs_b)?1'b1:1'b0;

assign cDEN = hori_valid && vert_valid;

always@(negedge clk)
begin
  vga_hsy <=cHD;   
  vga_vsy <=cVD;
  adv7123_blank_n <=cDEN;  //有效区域的电平flag
end

assign adv7123_sync_n = 1'b0;


// always @(posedge clk or negedge rst_n)
// 	if(!rst_n) hx_cnt <= 12'd0;
// 	else if(hx_cnt >= Hs_t) hx_cnt <= 12'd0;
// 	else hx_cnt <= hx_cnt+1'b1;

// always @(posedge clk or negedge rst_n)
// 	if(!rst_n) vy_cnt <= 12'd0;
// 	else if(hx_cnt == Hs_t) begin
// 		if(vy_cnt >= Vs_t) vy_cnt <= 12'd0;
// 		else vy_cnt <= vy_cnt+1'b1;
// 	end
// 	else ;
		
// //-----------------------------------------------------------				
// always @(posedge clk or negedge rst_n)
// 	if(!rst_n) vga_hsy <= 1'b0;
// 	else if(hx_cnt < Hs_a) vga_hsy <= 1'b1;
// 	else vga_hsy <= 1'b0;
	
// always @(posedge clk or negedge rst_n)
// 	if(!rst_n) vga_vsy <= 1'b0;
// 	else if(vy_cnt < Vs_a) vga_vsy <= 1'b1;
// 	else vga_vsy <= 1'b0;	
	
// //-----------------------------------------------------------				
// reg vga_valid;

// always @(posedge clk or negedge rst_n)
// 	if(!rst_n) vga_valid <= 1'b0;
// 	else if((hx_cnt >= (Hs_a+Hs_b-1)) && (hx_cnt < (Hs_a+Hs_b+Hs_c))
// 			&& (vy_cnt >= (Vs_a+Vs_b-1)) && (vy_cnt < (Vs_a+Vs_b+Vs_c)))
// 		 vga_valid <= 1'b1;
// 	else vga_valid <= 1'b0;

// assign adv7123_blank_n = vga_valid;
// assign adv7123_sync_n = 1'b0;
	
//-----------------------------------------------------------				
reg[7:0] vga_rdb;
reg[7:0] vga_gdb;
reg[7:0] vga_bdb;

parameter X0= 12'd100;
parameter X1= X0 + 12'd100;

parameter Y0= 12'd200;
parameter Y1= Y0 +12'd200;
wire hori_valid1,vert_valid1;
wire hori_valid2,vert_valid2;
// assign hori_valid1 = (hx_cnt<(Hs_t-Hs_d-X0)&& hx_cnt>=Hs_b+X1)?1'b1:1'b0;

//单独横条
assign vert_valid1 = (vy_cnt>(Vs_a+Vs_b)&& vy_cnt<=Vs_a+Vs_b+X0)?1'b1:1'b0;
assign vert_valid2 = (vy_cnt>(Vs_a+Vs_b+X0)&& vy_cnt<=Vs_a+Vs_b+X1)?1'b1:1'b0;
//单独竖条纹
assign hori_valid1 = (hx_cnt>(Hs_a+Hs_b)&& hx_cnt<=Hs_a+Hs_b+Y0)?1'b1:1'b0;
assign hori_valid2 = (hx_cnt>(Hs_a+Hs_b+Y0)&& hx_cnt<=Hs_a+Hs_b+Y1)?1'b1:1'b0;


// 回字形状的图像
// assign hori_valid1 = (hx_cnt<(Hs_t-Hs_d-X0)&& hx_cnt>=Hs_b+X1)?1'b1:1'b0;
// assign vert_valid1 = (vy_cnt<(Vs_t-Vs_d-Y0)&& vy_cnt>=Vs_b+X1)?1'b1:1'b0;

always @(posedge clk or negedge rst_n) begin : proc_1
	if(~rst_n) begin
			vga_rdb <= 8'h0;
			vga_gdb <= 8'h0;
			vga_bdb <= 8'h0;
	end else begin
		if(vert_valid1 && hori_valid1) begin
			vga_rdb <= 8'h0;
			vga_gdb <= 8'h3f;
			vga_bdb <= 8'h0;
		end
		else if(vert_valid2  && hori_valid2) begin
			vga_rdb <= 8'h3f;
			vga_gdb <= 8'h0;
			vga_bdb <= 8'h0;
		end
		else begin
			vga_rdb <= 8'h0;
			vga_gdb <= 8'h0;
			vga_bdb <= 8'h3f;
		end
	end
end


// always @(posedge clk or negedge rst_n)
// begin
// 	if(~rst_n) begin
// 		vga_rdb <= 8'h0;
// 		vga_gdb <= 8'h0;
// 		vga_bdb <= 8'h0;
// 	end
// 	else if(hx_cnt == (Hs_a+Hs_b-1)) begin								
// 		vga_rdb <= 8'h0;
// 		vga_gdb <= 8'h3f;
// 		vga_bdb <= 8'h0;		
// 	end
// 	else if(hx_cnt == (Hs_a+Hs_b+Hs_c-1'b1)) begin					
// 		vga_rdb <= 8'h0;
// 		vga_gdb <= 8'h3f;
// 		vga_bdb <= 8'h0;		
// 	end
// 	else if(vy_cnt == (Vs_a+Vs_b-1)) begin								
// 		vga_rdb <= 8'h0;
// 		vga_gdb <= 8'h3f;
// 		vga_bdb <= 8'h0;		
// 	end
// 	else if(vy_cnt == (Vs_a+Vs_b+Vs_c-1'b1)) begin					
// 		vga_rdb <= 8'h0;
// 		vga_gdb <= 8'h3f;
// 		vga_bdb <= 8'h0;		
// 	end
// 	else begin																
// 		vga_rdb <= 8'h0;
// 		vga_gdb <= 8'h0;
// 		vga_bdb <= 8'h1f;	
// 	end
// end
//-----------------------------------------------------------				
assign vga_r = cDEN ? vga_rdb:8'd0;
assign vga_g = cDEN ? vga_gdb:8'd0;	
assign vga_b = cDEN ? vga_bdb:8'd0;	
	
endmodule
