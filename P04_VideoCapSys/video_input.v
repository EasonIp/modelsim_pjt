
module video_input(
				clk,clk_100m,rst_n,
				vpclk,vvsync,vhref,vdb,vscl,vsda,
				wrf_din,wrf_wrreq
			);

input clk;			//ϵͳʱ�ӣ�25MHz
input clk_100m;	//PLL���100MHzʱ��
input rst_n;		//��λ�źţ��͵�ƽ��Ч
	//��Ƶ����ӿ�
input vpclk;		//��Ƶʱ��
input vvsync;	//��Ƶ��ͬ���ź�
input vhref;		//��Ƶ��ͬ���ź�
input[7:0] vdb;	//��Ƶ��������
output vscl;	//��������IICʱ���ź�
inout vsda;	//��������IIC�����ź�
	//wrFIFO������ƽӿ�
output[15:0] wrf_din;		//sdram����д�뻺��FIFO������������
output wrf_wrreq;			//sdram����д�뻺��FIFO�����������󣬸���Ч

//------------------------------------------------
	//��ƵIIC���ö˿�
wire tiic_en;		//��Ҫͨ��IIC�ӿ�����MAX9526ʹ���źţ��ߵ�ƽ��Ч
wire[7:0] tiic_ab;	//��Ҫͨ��IIC�ӿ�����MAX9526��ַ
wire[7:0] tiic_db;	//��Ҫͨ��IIC�ӿ�����MAX9526����	


//------------------------------------------------
//IICʱ�����ģ��
iic_ctrl	uut_iicctrl(
				.clk(clk),
				.rst_n(rst_n),
				.tiic_en(tiic_en),
				.tiic_ab(tiic_ab),
				.tiic_db(tiic_db),
				.scl(vscl),
				.sda(vsda)
			);

//------------------------------------------------
//IIC�Ĵ���
iic_gene	uut_iicgene(
				.clk(clk),
				.rst_n(rst_n),
				.tiic_en(tiic_en),
				.tiic_ab(tiic_ab),
				.tiic_db(tiic_db)
			);

//------------------------------------------------
//��Ƶ���뻺�����
video_ctrl	uut_videoctrl(
				.clk(clk_100m),
				.rst_n(rst_n),
				.vpclk(vpclk),
				.vvsync(vvsync),
				.vhref(vhref),
				.vdb(vdb),
				.wrf_din(wrf_din),
				.wrf_wrreq(wrf_wrreq)
			);

endmodule

