
module iic_gene(
				clk,rst_n,
				tiic_en,tiic_ab,tiic_db
			);

input clk;		// 50MHz��ʱ��
input rst_n;		//�͵�ƽ��λ�ź�

output tiic_en;		//��Ҫͨ��IIC�ӿ�����MAX9526ʹ���źţ��ߵ�ƽ��Ч
output reg[7:0] tiic_ab;	//��Ҫͨ��IIC�ӿ�����MAX9526��ַ
output reg[7:0] tiic_db;	//��Ҫͨ��IIC�ӿ�����MAX9526����	

//-------------------------------------------------------
//��ʼ������ROM����
wire[6:0] romab;
wire[15:0] romdb;

iic_initrom 		uut_iicinitrom(
					.address(romab),
					.clock(clk),
					.q(romdb)
				);
	
//-------------------------------------------------------
//�ϵ���ʱ20ms
reg[19:0] dcnt;	//��ʱ������
reg[6:0] mcnt;	//mcnt��20ms��������

always @(posedge clk or negedge rst_n)
	if(!rst_n) dcnt <= 20'd0;
	else if(mcnt < 7'd127) begin
		if(dcnt < 20'd30000) dcnt <= dcnt+1'b1;
		else dcnt <= 20'd0;
	end
		
wire wren = (dcnt == 20'd1000);	
	
//-------------------------------------------------------
//20ms�������ڿ���

always @(posedge clk or negedge rst_n)
	if(!rst_n) mcnt <= 7'd0;
	else if(dcnt == 20'd2000) mcnt <= mcnt+1'b1;
	
//-------------------------------------------------------
//��ʼ���Ĵ�������
	//12H��ַ����Ϊ14H��bit4=1--QVGAģʽ��bit2=1,bit0=0--RGBģʽ
parameter	RIDLE = 3'd0;
parameter	RSET1 = 3'd1;
parameter	ROVER = 3'd2;
reg[2:0] rstate;	
	
always @(posedge clk or negedge rst_n)	
	if(!rst_n) begin
		rstate <= RIDLE;
		tiic_ab <= 8'd0;
		tiic_db <= 8'd0;
	end
	else begin
		case(rstate)
			RIDLE:	if((mcnt > 7'd6) && wren) begin
						rstate <= RSET1;
						tiic_ab <= romdb[15:8];
						tiic_db <= romdb[7:0];
					end
					else if(mcnt == 7'd126) rstate <= ROVER;
					else rstate <= RIDLE;
			RSET1:	rstate <= RIDLE;
			ROVER: 	rstate <= ROVER;
			default: rstate <= RIDLE;
		endcase
	end
	
assign tiic_en = (rstate == RSET1);		//IICд�������ź�
assign romab = mcnt-7'd7;


endmodule
