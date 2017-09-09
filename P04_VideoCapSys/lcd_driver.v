
module lcd_driver(	
				clk,rst_n,
				lcd_en,lcd_clk,lcd_hsy,lcd_vsy,lcd_db_r,lcd_db_g,lcd_db_b,
				rdfifo_rddb,rdfifo_rdreq,rdfifo_clr
			);
input clk;		//25MHz
input rst_n;	//�͵�ƽ��λ
	// FPGA��LCD�ӿ��ź�
output lcd_en;	//����ʹ���źţ�����Ч
output lcd_clk;	//ʱ���ź�	
output lcd_hsy;	//��ͬ���ź�
output lcd_vsy;	//��ͬ���ź�
output[4:0] lcd_db_r;
output[5:0] lcd_db_g;
output[4:0] lcd_db_b;
	//LCD��FIFO�Ľӿ�
input[15:0] rdfifo_rddb;		//FIFO������������
output rdfifo_rdreq;	//FIFO�������ź�
output rdfifo_clr;		//FIFO��λ�źţ��ߵ�ƽ��Ч

//---------------------------------------------
assign lcd_en = 1'b1;

//---------------------------------------------
//lcd_clkʱ������Ϊ160ns(6.25MHz),��4��25MHz��ʱ������
reg[1:0] sft_cnt;

always @(posedge clk or negedge rst_n)
	if(!rst_n) sft_cnt <= 2'd0;
	else sft_cnt <= sft_cnt+1'b1;

assign lcd_clk = sft_cnt[1];	//0-1:low,2-3:high

wire dchange = (sft_cnt == 2'd2);	//���ݱ仯��־λ������Ч

//---------------------------------------------		
//������� 
//x = 0-407;  y = 0-261
reg[8:0] x_cnt;	//x������
reg[8:0] y_cnt;	//y������

always @(posedge clk or negedge rst_n)
	if(!rst_n) x_cnt <= 9'd0;
	else if(dchange) begin
		if(x_cnt == 9'd407) x_cnt <= 9'd0;
		else x_cnt <= x_cnt+1'b1;  
	end

always @(posedge clk or negedge rst_n)
	if(!rst_n) y_cnt <= 9'd0;
	else if(dchange && (x_cnt == 9'd407)) begin
		if(y_cnt == 9'd261) y_cnt <= 9'd0;
		else y_cnt <= y_cnt+1'b1;  
	end	

//--------------------------------------------------
//��Ч��ʾ��־λ����
reg valid_yr;	//����ʾ��Ч�ź�

	//����ʾ��Ч�ź�
always @ (posedge clk or negedge rst_n)
	if(!rst_n) valid_yr <= 1'b0;
	else if(y_cnt == 9'd16) valid_yr <= 1'b1;	
	else if(y_cnt == 9'd256) valid_yr <= 1'b0;

reg validr,valid;

always @ (posedge clk or negedge rst_n)
	if(!rst_n) validr <= 1'b0;
	else if((x_cnt == 9'd67) && valid_yr) validr <= 1'b1;
	else if((x_cnt == 9'd387) && valid_yr) validr <= 1'b0;
	
always @ (posedge clk or negedge rst_n)
	if(!rst_n) valid <= 1'b0;
	else valid <= validr;
	
//--------------------------------------------------
// LCD��ͬ��,��ͬ���ź�
reg lcd_hsy_r,lcd_vsy_r;	//ͬ���ź�
 
always @ (posedge clk or negedge rst_n)
	if(!rst_n) lcd_hsy_r <= 1'b1;								
	else if(x_cnt == 9'd0) lcd_hsy_r <= 1'b0;	//����lcd_hsy�ź�
	else if(x_cnt == 9'd30) lcd_hsy_r <= 1'b1;

always @ (posedge clk or negedge rst_n)
	if(!rst_n) lcd_vsy_r <= 1'b1;							  
	else if(y_cnt == 9'd0) lcd_vsy_r <= 1'b0;	//����lcd_vsy�ź�
	else if(y_cnt == 9'd3) lcd_vsy_r <= 1'b1;

assign lcd_hsy = lcd_hsy_r;
assign lcd_vsy = lcd_vsy_r;	

//--------------------------------------------------
	//FIFO�������źź͸�λ�źŲ���
assign rdfifo_rdreq = validr & (sft_cnt == 2'd3);
assign rdfifo_clr = (y_cnt == 9'd0);

//-------------------------------------------------- 
	// LCDɫ���źŲ���
reg[15:0] lcd_db_rgb;	// LCDɫ����ʾ�Ĵ���

always @ (posedge clk or negedge rst_n)
	if(!rst_n) lcd_db_rgb <= 16'd0;
	else lcd_db_rgb <= rdfifo_rddb;

	//r,g,b����Һ������ɫ��ʾ
assign lcd_db_r = valid ? lcd_db_rgb[15:11]:5'd0;
assign lcd_db_g = valid ? lcd_db_rgb[10:5]:6'd0;
assign lcd_db_b = valid ? lcd_db_rgb[4:0]:5'd0;

endmodule

