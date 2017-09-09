/*
 文件名称：music.v

 描述：演奏3首曲子，《欢乐颂》，《致爱丽丝》，《梁祝》
*/
 
module music (clk, rst_n, beep);
	
	input					clk;
	input					rst_n;
	output				beep;
	
	reg					beep;

//------------时钟分频计数值-----------------------------------------------------------------
	
	parameter SPEED 		= 8; //控制演奏的速度，如果是4，频率就是4hz
	parameter COUNTER_6M = 50_000_000 / 6_000_000 / 2 - 1;	//基准频率分频比
	parameter COUNTER_4	= 50_000_000 / SPEED / 2 - 1;	//演奏频率分频比
	parameter LENGTH 		= 200;
	
//------------音阶分频预置数------------------------------------------------------------------
//预置数 = 16383 -	(6_000_000 / 音阶频率	/ 2 - 1)
//分频比 = 6_000_000 / 音阶频率	/ 2 - 1
	
	parameter REST	  = 2^14 - 1;	//休止符 不发出声音 2^14 - 1 = 16383
	
	parameter C_LOW  = 16383 - (6_000_000 / 262 / 2 - 1);	//低音C
	parameter D_LOW  = 16383 - (6_000_000 / 294 / 2 - 1);
	parameter E_LOW  = 16383 - (6_000_000 / 330 / 2 - 1);
	parameter F_LOW  = 16383 - (6_000_000 / 349 / 2 - 1);
	parameter G_LOW  = 16383 - (6_000_000 / 392 / 2 - 1);
	parameter A_LOW  = 16383 - (6_000_000 / 440 / 2 - 1);
	parameter B_LOW  = 16383 - (6_000_000 / 494 / 2 - 1);
	
	parameter C_MID  = 16383 - (6_000_000 / 523 / 2 - 1);	//中音C
	parameter D_MID  = 16383 - (6_000_000 / 587 / 2 - 1);
	parameter E_MID  = 16383 - (6_000_000 / 659 / 2 - 1);
	parameter F_MID  = 16383 - (6_000_000 / 699 / 2 - 1);
	parameter G_MID  = 16383 - (6_000_000 / 784 / 2 - 1);
	parameter A_MID  = 16383 - (6_000_000 / 880 / 2 - 1);
	parameter B_MID  = 16383 - (6_000_000 / 988 / 2 - 1);
	
	parameter C_HIGH = 16383 - (6_000_000 / 1047 / 2 - 1);	//高音C
	parameter D_HIGH = 16383 - (6_000_000 / 1175 / 2 - 1);
	parameter E_HIGH = 16383 - (6_000_000 / 1319 / 2 - 1);
	parameter F_HIGH = 16383 - (6_000_000 / 1397 / 2 - 1);
	parameter G_HIGH = 16383 - (6_000_000 / 1568 / 2 - 1);
	parameter A_HIGH = 16383 - (6_000_000 / 1760 / 2 - 1);
	parameter B_HIGH = 16383 - (6_000_000 / 1976 / 2 - 1);

//---------------基准时钟分频6mhz--------------------------------------------------------------
	
	reg		[23:0]			cnt_6m;
	reg							clk_6m;
	
	always @(posedge clk or negedge rst_n)
		begin
			if (!rst_n)
				begin
					cnt_6m <= 0;
					clk_6m <= 0;
				end
			else if (cnt_6m == COUNTER_6M)
				begin
					cnt_6m <= 0;
					clk_6m <= ~ clk_6m;
				end
			else
				cnt_6m <= cnt_6m + 1'b1;
		end

//-----------------演奏时钟分频4hz---------------------------------------------------------------

	reg		[23:0]			cnt_4;
	reg							clk_4;
	
	always @(posedge clk or negedge rst_n)
		begin
			if (!rst_n)
				begin
					cnt_4 <= 0;
					clk_4 <= 0;
				end
			else if (cnt_4 == COUNTER_4)
				begin
					cnt_4 <= 0;
					clk_4 <= ~ clk_4;
				end
			else
				cnt_4 <= cnt_4 + 1'b1;
		end

//------------------------------------------------------------------------------------------------

	reg		[13:0]		cnt;
	
	always @(posedge clk_6m or negedge rst_n)
		begin
			if (!rst_n)
				cnt <= 0;
			else if (cnt == REST)
				begin
					cnt <= cnt_hz;
					beep <= ~ beep;	//无源蜂鸣器需要产生方波驱动
				end
			else
				cnt <= cnt + 1'b1;
		end
 
//------------------------------------------------------------------------------------------------

	reg		[13:0]		cnt_hz;

	always @(posedge clk_4 or negedge rst_n)	//根据不同的音阶选择不同的预置数
		begin
			if (!rst_n)
				cnt_hz <= REST;
			else
				case (music_scale)
					0 : cnt_hz <= REST;
					1 : cnt_hz <= C_LOW;
					2 : cnt_hz <= D_LOW;
					3 : cnt_hz <= E_LOW;
					4 : cnt_hz <= F_LOW;
					5 : cnt_hz <= G_LOW;
					6 : cnt_hz <= A_LOW;
					7 : cnt_hz <= B_LOW;
					8 : cnt_hz <= C_MID;
					9 : cnt_hz <= D_MID;
					10 : cnt_hz <= E_MID;
					11 : cnt_hz <= F_MID;
					12 : cnt_hz <= G_MID;
					13 : cnt_hz <= A_MID;
					14 : cnt_hz <= B_MID;
					15 : cnt_hz <= C_HIGH;
					16 : cnt_hz <= D_HIGH;
					17 : cnt_hz <= E_HIGH;
					18 : cnt_hz <= F_HIGH;
					19 : cnt_hz <= G_HIGH;
					20 : cnt_hz <= A_HIGH;
					21 : cnt_hz <= B_HIGH;
					default : cnt_hz <= REST;
				endcase
		end
		
//------------------------------------------------------------------------------------------------
//如果SPEED = 4，那么就代表一个计数一次是0.25s
//如果SPEED = 8 ，那么就代表一次计数是0.125s
//每次只能演奏一首曲子，想演奏那首曲子，就将该曲子的注释去掉，把其他曲子注释掉
	reg		[23:0]		cnt_l;//演奏计数器
	reg		[5:0]			music_scale;//音阶
// 0 休止符 // 1-7 低音 // 8-14 中音 // 15-21 高音 //
//clk_4频率为4，那么每0.25秒计数一次即每0.25秒演奏一个音阶
//每个音阶的计数次数可以表示音长
	always @ (posedge clk_4 or negedge rst_n)	
		begin												
			if (!rst_n)
				begin
					cnt_l <= 0;
					music_scale <= 0;
				end
			else if (cnt_l == LENGTH)//每计数到LENGTH 循环一次 
				cnt_l <= 0;
			else
				cnt_l <= cnt_l + 1'b1;
				case (cnt_l)
//《欢乐颂》	speed = 6
					0:music_scale<=10;//乐谱，计数两次就代表音阶10持续了0.5s
					1:music_scale<=10;
					2:music_scale<=0;
					3:music_scale<=10;
					4:music_scale<=10;
					5:music_scale<=0;
					6:music_scale<=11;
					7:music_scale<=11;
					8:music_scale<=0;
					9:music_scale<=12;
					10:music_scale<=12;
					11:music_scale<=0;
					
					12:music_scale<=12;
					13:music_scale<=12;
					14:music_scale<=0;
					15:music_scale<=11;
					16:music_scale<=11;
					17:music_scale<=0;
					18:music_scale<=10;
					19:music_scale<=10;
					20:music_scale<=0;
					21:music_scale<=9;
					22:music_scale<=9;
					23:music_scale<=0;
					
					24:music_scale<=8;
					25:music_scale<=8;
					26:music_scale<=0;
					27:music_scale<=8;
					28:music_scale<=8;
					29:music_scale<=0;
					30:music_scale<=9;
					31:music_scale<=9;
					32:music_scale<=0;
					33:music_scale<=10;
					34:music_scale<=10;
					35:music_scale<=0;
					
					36:music_scale<=10;
					37:music_scale<=10;
					38:music_scale<=0;
					39:music_scale<=0;
					40:music_scale<=9;
					41:music_scale<=0;
					42:music_scale<=9;
					43:music_scale<=9;	
					44:music_scale<=0;
					45:music_scale<=0;
					46:music_scale<=0;
					
					47:music_scale<=10;
					48:music_scale<=10;
					49:music_scale<=0;
					50:music_scale<=10;
					51:music_scale<=10;
					52:music_scale<=0;
					53:music_scale<=11;
					54:music_scale<=11;
					55:music_scale<=0;
					56:music_scale<=12;
					57:music_scale<=12;
					58:music_scale<=0;
					
					59:music_scale<=12;
					60:music_scale<=12;
					61:music_scale<=0;
					62:music_scale<=11;
					63:music_scale<=11;
					64:music_scale<=0;
					65:music_scale<=10;
					66:music_scale<=10;
					67:music_scale<=0;
					68:music_scale<=9;
					69:music_scale<=9;
					70:music_scale<=0;
					
					71:music_scale<=8;
					72:music_scale<=8;
					73:music_scale<=0;
					74:music_scale<=8;
					75:music_scale<=8;
					76:music_scale<=0;
					77:music_scale<=9;
					78:music_scale<=9;
					79:music_scale<=0;
					80:music_scale<=10;
					81:music_scale<=10;
					82:music_scale<=0;
					
					83:music_scale<=9;
					84:music_scale<=9;
					85:music_scale<=0;
					86:music_scale<=0;
					87:music_scale<=8;
					88:music_scale<=0;
					89:music_scale<=8;
					90:music_scale<=8;
					91:music_scale<=0;
					92:music_scale<=0;
					93:music_scale<=0;
					
					94:music_scale<=9;
					95:music_scale<=9;
					96:music_scale<=0;
					97:music_scale<=9;
					98:music_scale<=9;
					99:music_scale<=0;
					100:music_scale<=10;
					101:music_scale<=10;
					102:music_scale<=0;
					103:music_scale<=8;
					104:music_scale<=8;
					105:music_scale<=0;
					
					106:music_scale<=9;
					107:music_scale<=9;
					108:music_scale<=0;
					109:music_scale<=10;
					110:music_scale<=11;
					111:music_scale<=0;
					112:music_scale<=10;
					113:music_scale<=10;
					114:music_scale<=0;
					115:music_scale<=8;
					116:music_scale<=8;
					117:music_scale<=0;
					
					118:music_scale<=9;
					119:music_scale<=9;
					120:music_scale<=0;
					121:music_scale<=10;
					122:music_scale<=11;
					123:music_scale<=0;
					124:music_scale<=10;
					125:music_scale<=10;
					126:music_scale<=0;
					127:music_scale<=9;
					128:music_scale<=9;
					129:music_scale<=0;
					
					130:music_scale<=8;
					131:music_scale<=8;
					132:music_scale<=0;
					133:music_scale<=9;
					134:music_scale<=9;
					135:music_scale<=0;
					136:music_scale<=5;
					137:music_scale<=5;
					138:music_scale<=0;
					139:music_scale<=10;
					140:music_scale<=10;

					141:music_scale<=10;
					142:music_scale<=10;
					143:music_scale<=0;
					144:music_scale<=10;
					145:music_scale<=10;
					146:music_scale<=0;
					147:music_scale<=11;
					148:music_scale<=11;
					149:music_scale<=0;
					150:music_scale<=12;
					151:music_scale<=12;
					152:music_scale<=0;
					
					153:music_scale<=12;
					154:music_scale<=12;
					155:music_scale<=0;
					156:music_scale<=11;
					157:music_scale<=11;
					158:music_scale<=0;
					159:music_scale<=10;
					160:music_scale<=10;
					161:music_scale<=0;
					162:music_scale<=11;
					163:music_scale<=9;
					164:music_scale<=0;
					
					165:music_scale<=8;
					166:music_scale<=8;
					167:music_scale<=0;
					168:music_scale<=8;
					169:music_scale<=8;
					170:music_scale<=0;
					171:music_scale<=9;
					172:music_scale<=9;
					173:music_scale<=0;
					174:music_scale<=10;
					175:music_scale<=10;
					176:music_scale<=0;

					177:music_scale<=9;
					178:music_scale<=9;
					179:music_scale<=0;
					180:music_scale<=0;
					181:music_scale<=8;
					182:music_scale<=0;
					183:music_scale<=8;
					184:music_scale<=8;
					185:music_scale<=0;
					186:music_scale<=0;
					187:music_scale<=0;
//《致爱丽丝》 SPEED = 6
/*					0:music_scale<=17;
					1:music_scale<=17;
					2:music_scale<=16;
					3:music_scale<=16;
					4:music_scale<=17;
					5:music_scale<=17;
					6:music_scale<=14;
					7:music_scale<=14;
					8:music_scale<=16;
					9:music_scale<=16;
					10:music_scale<=15;
					11:music_scale<=15;
					12:music_scale<=13;
					13:music_scale<=13;
					14:music_scale<=13;
					15:music_scale<=13;
					16:music_scale<=0;
					17:music_scale<=0;
					18:music_scale<=8;
					19:music_scale<=8;
					20:music_scale<=10;
					21:music_scale<=10;
					22:music_scale<=13;
					23:music_scale<=13;
					24:music_scale<=14;
					25:music_scale<=14;
					26:music_scale<=14;
					27:music_scale<=14;
					28:music_scale<=0;
					29:music_scale<=0;
					30:music_scale<=10;
					31:music_scale<=10;
					32:music_scale<=12;
					33:music_scale<=12;
					34:music_scale<=14;
					35:music_scale<=14;
					36:music_scale<=15;
					37:music_scale<=15;
					38:music_scale<=15;
					39:music_scale<=15;
					40:music_scale<=0;
					41:music_scale<=0;
					42:music_scale<=10;
					43:music_scale<=10;
					44:music_scale<=17;
					45:music_scale<=17;
					46:music_scale<=16;
					47:music_scale<=16;
					48:music_scale<=17;
					49:music_scale<=17;
					50:music_scale<=16;
					51:music_scale<=16;
					52:music_scale<=17;
					53:music_scale<=17;
					54:music_scale<=14;
					55:music_scale<=14;
					56:music_scale<=16;
					57:music_scale<=16;
					58:music_scale<=15;
					59:music_scale<=15;
					60:music_scale<=13;
					61:music_scale<=13;
					62:music_scale<=13;
					63:music_scale<=13;
					64:music_scale<=0;
					65:music_scale<=0;
					66:music_scale<=8;
					67:music_scale<=8;
					68:music_scale<=10;
					69:music_scale<=10;
					70:music_scale<=13;
					71:music_scale<=13;
					72:music_scale<=14;
					73:music_scale<=14;
					74:music_scale<=14;
					75:music_scale<=14;
					76:music_scale<=0;
					77:music_scale<=0;
					78:music_scale<=10;
					79:music_scale<=10;
					80:music_scale<=15;
					81:music_scale<=15;
					82:music_scale<=14;
					83:music_scale<=14;
					84:music_scale<=13;
					85:music_scale<=13;
					86:music_scale<=13;
					87:music_scale<=13;
					88:music_scale<=13;
					89:music_scale<=13;
					90:music_scale<=13;
					91:music_scale<=13;*/
//《梁祝》 SPEED = 4
/*					0:music_scale<=3;
					1:music_scale<=3;
					2:music_scale<=3;
					3:music_scale<=3;
					4:music_scale<=5;
					5:music_scale<=5;
					6:music_scale<=5;
					7:music_scale<=6;
					8:music_scale<=8;
					9:music_scale<=8;
					10:music_scale<=8;
					11:music_scale<=9;
					12:music_scale<=6;
					13:music_scale<=8;
					14:music_scale<=5;
					15:music_scale<=5;
					16:music_scale<=12;
					17:music_scale<=12;
					18:music_scale<=12;
					19:music_scale<=15;
					20:music_scale<=13;
					21:music_scale<=12;
					22:music_scale<=10;
					23:music_scale<=12;
					24:music_scale<=9;
					25:music_scale<=9;
					26:music_scale<=9;
					27:music_scale<=9;
					28:music_scale<=9;
					29:music_scale<=9;
					30:music_scale<=9;
					31:music_scale<=9;
					32:music_scale<=9;
					33:music_scale<=9;
					34:music_scale<=9;
					35:music_scale<=10;
					36:music_scale<=7;
					37:music_scale<=7;
					38:music_scale<=6;
					39:music_scale<=6;
					40:music_scale<=5;
					41:music_scale<=5;
					42:music_scale<=5;
					43:music_scale<=6;
					44:music_scale<=8;
					45:music_scale<=8;
					46:music_scale<=9;
					47:music_scale<=9;
					48:music_scale<=3;
					49:music_scale<=3;
					50:music_scale<=8;
					51:music_scale<=8;
					52:music_scale<=6;
					53:music_scale<=5;
					54:music_scale<=6;
					55:music_scale<=8;
					56:music_scale<=5;
					57:music_scale<=5;
					58:music_scale<=5;
					59:music_scale<=5;
					60:music_scale<=5;
					61:music_scale<=5;
					62:music_scale<=5;
					63:music_scale<=5;*/
					default : music_scale <= 0;
				endcase
		end

//------------------------------------------------------------------------------------------------

endmodule
		