
module sdfifo_ctrl(
				clk_25m,clk_100m,rst_n,
				wrf_clr,wrf_din,wrf_wrreq,
				sdram_wr_ack,sys_wraddr,sys_rdaddr,sys_data_in,sdram_wr_req,
				sys_data_out,sdram_rd_ack,sdram_rd_req,
				rdfifo_rdreq,rdfifo_clr,rdfifo_rddb
			);

input clk_25m;	//PLL���25MHzʱ��
input clk_100m;	//PLL���100MHzʱ��
input rst_n;	//ϵͳ��λ�źţ�����Ч
	//wrFIFO����
input wrf_clr;			//sdram����д�뻺��FIFO��λ�źţ��ߵ�ƽ��Ч
input wrf_wrreq;			//sdram����д�뻺��FIFO�����������󣬸���Ч
input[15:0] wrf_din;		//sdram����д�뻺��FIFO������������
input sdram_wr_ack;			//ϵͳдSDRAM��Ӧ�ź�,��ΪwrFIFO�������Ч�ź�
output sdram_wr_req;		//ϵͳдSDRAM�����ź�
output[15:0] sys_data_in;	//sdram����д�뻺��FIFO����������ߣ���дSDRAMʱ�����ݴ���
output[21:0] sys_wraddr;	//дSDRAMʱ��ַ�ݴ�����(bit21-20)L-Bank��ַ:(bit19-8)Ϊ�е�ַ��(bit7-0)Ϊ�е�ַ 
	//rdFIFOд�����
input sdram_rd_ack;			//ϵͳ��SDRAM��Ӧ�ź�,��ΪrdFIFO����д��Ч�ź�
input[15:0] sys_data_out;	//sdram���ݶ�������FIFO������������
output sdram_rd_req;		//ϵͳ��SDRAM�����ź�
output[21:0] sys_rdaddr;	//��SDRAMʱ��ַ�ݴ�����(bit21-20)L-Bank��ַ:(bit19-8)Ϊ�е�ַ��(bit7-0)Ϊ�е�ַ 
	//rdFIFO��������
input rdfifo_rdreq;			//sdram���ݶ�������FIFO����������󣬸���Ч
input rdfifo_clr;		//����Ч������ʹ��SDRAM�����ݵ�Ԫ����Ѱַ���ַ����
output[15:0] rdfifo_rddb;	//VGA��ʾ����

//------------------------------------------------
//sdram��д��Ӧ��ɱ��²���
reg sdwrackr1,sdwrackr2;	//sdram_wr_ack�Ĵ���
reg sdrdackr1,sdrdackr2;	//sdram_rd_ack�Ĵ���

	//��������sdram_wr_ack�������½��ز���
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) begin
			sdwrackr1 <= 1'b0;
			sdwrackr2 <= 1'b0;
		end
	else begin
			sdwrackr1 <= sdram_wr_ack;
			sdwrackr2 <= sdwrackr1;			
		end
		
wire neg_sdwrack = ~sdwrackr1 & sdwrackr2;	//sdram_wr_ack�½��ر�־λ������Чһ��ʱ������

	//��������sdram_rd_ack�������½��ز���
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) begin
			sdrdackr1 <= 1'b0;
			sdrdackr2 <= 1'b0;
		end
	else begin
			sdrdackr1 <= sdram_rd_ack;
			sdrdackr2 <= sdrdackr1;			
		end
		
wire neg_sdrdack = ~sdrdackr1 & sdrdackr2;	//sdram_rd_ack�½��ر�־λ������Чһ��ʱ������

//------------------------------------------------
reg rdfifo_clrr;		//��50Mʱ�����rdfifo_clr��һ����ͬ����100M��rdfifo_clrr

always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) rdfifo_clrr <= 1'b0;
	else rdfifo_clrr <= rdfifo_clr;
	
//------------------------------------------------
reg wrf_clr_r;

always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) wrf_clr_r <= 1'b1;
	else wrf_clr_r <= wrf_clr;
	
//------------------------------------------------
//��дsdram�����źŲ���
wire[8:0] wrf_use;		//sdram����д�뻺��FIFO���ô洢�ռ�����
wire[8:0] rdf_use;		//sdram���ݶ�������FIFO���ô洢�ռ�����	

assign sdram_wr_req = (wrf_use > 9'd158);	//FIFO��160��16bit���ݣ�������дSDRAM�����ź�
assign sdram_rd_req = (rdf_use < 9'd350) & ~rdfifo_clrr;	//VGA��ʾ��Ч��FIFO����350�����ݼ�������SDRAM�����ź�

//------------------------------------------------
//sdramд��ַ�����߼�
reg[13:0] sys_wrabr;	//SDRAMд����ҳ

	//sdramд��ַ����
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sys_wrabr <= 14'd0;
	else if(wrf_clr_r) sys_wrabr <= 14'd0;	//����ʼ��ַд����
	else if(neg_sdwrack) sys_wrabr <= sys_wrabr+1'b1;	//һ��д����ɺ��ַ����	

assign sys_wraddr = {sys_wrabr,8'd0};

//------------------------------------------------
//sdram����ַ�����߼�
reg[13:0] sys_rdabr;	//SDRAM������ҳ

	//sdram����ַ����
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sys_rdabr <= 14'd0;
	else if(rdfifo_clrr) sys_rdabr <= 14'd0;	//����ʼ��ַ������
	else if(neg_sdrdack) sys_rdabr <= sys_rdabr+1'b1;	//һ�ζ�����ɺ��ַ����	

assign sys_rdaddr = {sys_rdabr,8'd0};

//------------------------------------------------
//����SDRAMд�����ݻ���FIFOģ��
wrfifo			uut_wrfifo(
					.aclr(wrf_clr_r),
					.data(wrf_din),
					.rdclk(clk_100m),
					.rdreq(sdram_wr_ack),
					.wrclk(clk_100m),
					.wrreq(wrf_wrreq),
					.q(sys_data_in),	//д���ַ���������
					.wrusedw(wrf_use)
					);						

//------------------------------------------------
//����SDRAM�������ݻ���FIFOģ��
rdfifo			uut_rdfifo(
					.aclr(rdfifo_clrr),
					.data(sys_data_out),
					.rdclk(clk_25m),
					.rdreq(rdfifo_rdreq),
					.wrclk(clk_100m),
					.wrreq(sdram_rd_ack),
					.q(rdfifo_rddb),
					.wrusedw(rdf_use)
					);


endmodule

