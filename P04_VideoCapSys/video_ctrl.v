
module video_ctrl(
				clk,rst_n,
				vpclk,vvsync,vhref,vdb,
				wrf_din,wrf_wrreq
			);

input clk;			//ϵͳʱ�ӣ�25MHz
input rst_n;		//��λ�źţ��͵�ƽ��Ч
	//��Ƶ����ӿ�
input vpclk;		//��Ƶʱ��
input vvsync;	//��Ƶ��ͬ���ź�
input vhref;		//��Ƶ��ͬ���ź�
input[7:0] vdb;	//��Ƶ��������
	//wrFIFO������ƽӿ�
output[15:0] wrf_din;		//sdram����д�뻺��FIFO������������
output wrf_wrreq;			//sdram����д�뻺��FIFO�����������󣬸���Ч

//-------------------------------------------------------
reg wrf_clr_r;	//wrf_clr_rͬ������һ��

always @(posedge clk or negedge rst_n)
	if(!rst_n) wrf_clr_r <= 1'b0;
	else wrf_clr_r <= vvsync;

//-------------------------------------------------------
//���ݻ���FIFO����
wire[7:0] vf_rduse;	//������Ч����

wire vf_rdreq = ~(dcnt == 8'd0);	//��FIFO����

video_fifo 	uut_videofifo(
				.aclr(wrf_clr_r),
				.data(vdb),
				.rdclk(clk),
				.rdreq(vf_rdreq),
				.wrclk(vpclk),
				.wrreq(vhref),
				.q({wrf_din[7:0],wrf_din[15:8]}),	//input first--LSB,input second--MSB
				.rdusedw(vf_rduse)
				);	

//-------------------------------------------------------
//д�������źŲ���
reg[7:0] dcnt;

always @(posedge clk or negedge rst_n)
	if(!rst_n) dcnt <= 8'd0;
	else if(vf_rduse > 8'd158) dcnt <= dcnt+1'b1;
	else if((dcnt != 8'd0) && (dcnt < 8'd160)) dcnt <= dcnt+1'b1;
	else dcnt <= 8'd0;

reg wrf_wrreqr;

always @(posedge clk or negedge rst_n)
	if(!rst_n) wrf_wrreqr <= 1'b0;
	else wrf_wrreqr <= vf_rdreq;

assign wrf_wrreq = wrf_wrreqr;	//sdram����д�뻺��FIFO�����������󣬸���Ч

endmodule

