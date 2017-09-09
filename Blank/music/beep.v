module beep (clk, rst_n, beep_out);
	
	input clk, rst_n;
	
	output reg beep_out;

//------------时钟分频计数值-----------------------------------------------------------------
	
	parameter SPEED 	= 8; //控制演奏的速度，如果是4，频率就是4hz
	parameter CNT_4P	= 25_000_000 / SPEED - 1;	//演奏频率分频比
	parameter LENGTH 	= 200;
	
//------------音阶分频预置数------------------------------------------------------------------
//预置数 = 16383 -	(6_000_000 / 音阶频率	/ 2 - 1)
//分频比 = 6_000_000 / 音阶频率	/ 2 - 1
	
	parameter CNT_PAUSE = 0;

	parameter CNT_C_LOW = 25_000_000_00 / SPEED / 261_63 - 1;
	parameter CNT_D_LOW = 25_000_000_00 / SPEED / 293_67 - 1;
	parameter CNT_E_LOW = 25_000_000_00 / SPEED / 329_63 - 1;
	parameter CNT_F_LOW = 25_000_000_00 / SPEED / 349_23 - 1;
	parameter CNT_G_LOW = 25_000_000_00 / SPEED / 391_99 - 1;
	parameter CNT_A_LOW = 25_000_000_00 / SPEED / 440_00 - 1;
	parameter CNT_B_LOW = 25_000_000_00 / SPEED / 493_88 - 1;

	parameter CNT_C_MID = 25_000_000_00 / SPEED / 523_25 - 1;
	parameter CNT_D_MID = 25_000_000_00 / SPEED / 587_33 - 1;
	parameter CNT_E_MID = 25_000_000_00 / SPEED / 659_25 - 1;
	parameter CNT_F_MID = 25_000_000_00 / SPEED / 698_46 - 1;
	parameter CNT_G_MID = 25_000_000_00 / SPEED / 783_99 - 1;
	parameter CNT_A_MID = 25_000_000_00 / SPEED / 880_00 - 1;
	parameter CNT_B_MID = 25_000_000_00 / SPEED / 987_76 - 1;

	parameter CNT_C_HIGH = 25_000_000_00 / SPEED / 1046_50 - 1;
	parameter CNT_D_HIGH = 25_000_000_00 / SPEED / 1174_66 - 1;
	parameter CNT_E_HIGH = 25_000_000_00 / SPEED / 1318_51 - 1;
	parameter CNT_F_HIGH = 25_000_000_00 / SPEED / 1396_92 - 1;
	parameter CNT_G_HIGH = 25_000_000_00 / SPEED / 1567_98 - 1;
	parameter CNT_A_HIGH = 25_000_000_00 / SPEED / 1760_00 - 1;
	parameter CNT_B_HIGH = 25_000_000_00 / SPEED / 1975_52 - 1;


//------------------------------------------------------------------------------------------------

	reg		[13:0]		cnt;
	
	always @(posedge clk or negedge rst_n)
		begin
			if (!rst_n)
				cnt <= 0;
			else if (cnt == cnt_hz)
				begin
					cnt <= 0;
					beep_out <= ~ beep_out;	//无源蜂鸣器需要产生方波驱动
				end
			else
				cnt <= cnt + 1'b1;
		end
 
//-----------------演奏时钟分频4hz---------------------------------------------------------------

	reg		[23:0]			cnt_4p;
	reg							clk_4p;
	
	always @(posedge clk or negedge rst_n)
		begin
			if (!rst_n)
				begin
					cnt_4p <= 0;
					clk_4p <= 0;
				end
			else if (cnt_4p == CNT_4P)
				begin
					cnt_4p <= 0;
					clk_4p <= ~ clk_4p;
				end
			else
				cnt_4p <= cnt_4p + 1'b1;
		end

//------------------------------------------------------------------------------------------------

	reg		[13:0]		cnt_hz;

	always @(posedge clk_4p or negedge rst_n)	//根据不同的音阶选择不同的预置数
		begin
			if (!rst_n)
				cnt_hz <= CNT_PAUSE;
			else
				case (music_scale)
					0	: cnt_hz <= CNT_PAUSE;
					1	: cnt_hz <= CNT_C_LOW;
					2	: cnt_hz <= CNT_D_LOW;
					3	: cnt_hz <= CNT_E_LOW;
					4	: cnt_hz <= CNT_F_LOW;
					5	: cnt_hz <= CNT_G_LOW;
					6	: cnt_hz <= CNT_A_LOW;
					7	: cnt_hz <= CNT_B_LOW;
					8	: cnt_hz <= CNT_C_MID;
					9	: cnt_hz <= CNT_D_MID;
					10 : cnt_hz <= CNT_E_MID;
					11 : cnt_hz <= CNT_F_MID;
					12 : cnt_hz <= CNT_G_MID;
					13 : cnt_hz <= CNT_A_MID;
					14 : cnt_hz <= CNT_B_MID;
					15 : cnt_hz <= CNT_C_HIGH;
					16 : cnt_hz <= CNT_D_HIGH;
					17 : cnt_hz <= CNT_E_HIGH;
					18 : cnt_hz <= CNT_F_HIGH;
					19 : cnt_hz <= CNT_G_HIGH;
					20 : cnt_hz <= CNT_A_HIGH;
					21 : cnt_hz <= CNT_B_HIGH;
					default : cnt_hz <= CNT_PAUSE;
				endcase
		end
		
//------------------------------------------------------------------------------------------------
//如果SPEED = 4，那么就代表一个计数一次是0.25s
//如果SPEED = 8 ，那么就代表一次计数是0.125s
//每次只能演奏一首曲子，想演奏那首曲子，就将该曲子的注释去掉，把其他曲子注释掉
// 0 休止符 // 1-7 低音 // 8-14 中音 // 15-21 高音 //
//clk_4频率为4，那么每0.25秒计数一次即每0.25秒演奏一个音阶
//每个音阶的计数次数可以表示音长
	reg		[23:0]		cnt_l;//演奏计数器
	reg		[5:0]			music_scale;//音阶

	always @ (posedge clk_4p or negedge rst_n)	
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
//《致爱丽丝》 SPEED = 6
					0	:	music_scale<=17;
					1	:	music_scale<=17;
					2	:	music_scale<=16;
					3	:	music_scale<=16;
					4	:	music_scale<=17;
					5	:	music_scale<=17;
					6	:	music_scale<=14;
					7	:	music_scale<=14;
					8	:	music_scale<=16;
					9	:	music_scale<=16;
					10	:	music_scale<=15;
					11	:	music_scale<=15;
					12	:	music_scale<=13;
					13	:	music_scale<=13;
					14	:	music_scale<=13;
					15	:	music_scale<=13;
					16	:	music_scale<=0;
					17	:	music_scale<=0;
					18	:	music_scale<=8;
					19	:	music_scale<=8;
					20	:	music_scale<=10;
					21	:	music_scale<=10;
					22	:	music_scale<=13;
					23	:	music_scale<=13;
					24	:	music_scale<=14;
					25	:	music_scale<=14;
					26	:	music_scale<=14;
					27	:	music_scale<=14;
					28	:	music_scale<=0;
					29	:	music_scale<=0;
					30	:	music_scale<=10;
					31	:	music_scale<=10;
					32	:	music_scale<=12;
					33	:	music_scale<=12;
					34	:	music_scale<=14;
					35	:	music_scale<=14;
					36	:	music_scale<=15;
					37	:	music_scale<=15;
					38	:	music_scale<=15;
					39	:	music_scale<=15;
					40	:	music_scale<=0;
					41	:	music_scale<=0;
					42	:	music_scale<=10;
					43	:	music_scale<=10;
					44	:	music_scale<=17;
					45	:	music_scale<=17;
					46	:	music_scale<=16;
					47	:	music_scale<=16;
					48	:	music_scale<=17;
					49	:	music_scale<=17;
					50	:	music_scale<=16;
					51	:	music_scale<=16;
					52	:	music_scale<=17;
					53	:	music_scale<=17;
					54	:	music_scale<=14;
					55	:	music_scale<=14;
					56	:	music_scale<=16;
					57	:	music_scale<=16;
					58	:	music_scale<=15;
					59	:	music_scale<=15;
					60	:	music_scale<=13;
					61	:	music_scale<=13;
					62	:	music_scale<=13;
					63	:	music_scale<=13;
					64	:	music_scale<=0;
					65	:	music_scale<=0;
					66	:	music_scale<=8;
					67	:	music_scale<=8;
					68	:	music_scale<=10;
					69	:	music_scale<=10;
					70	:	music_scale<=13;
					71	:	music_scale<=13;
					72	:	music_scale<=14;
					73	:	music_scale<=14;
					74	:	music_scale<=14;
					75	:	music_scale<=14;
					76	:	music_scale<=0;
					77	:	music_scale<=0;
					78	:	music_scale<=10;
					79	:	music_scale<=10;
					80	:	music_scale<=15;
					81	:	music_scale<=15;
					82	:	music_scale<=14;
					83	:	music_scale<=14;
					84	:	music_scale<=13;
					85	:	music_scale<=13;
					86	:	music_scale<=13;
					87	:	music_scale<=13;
					88	:	music_scale<=13;
					89	:	music_scale<=13;
					90	:	music_scale<=13;
					91	:	music_scale<=13;
					default : music_scale <= 0;
				endcase
		end

endmodule
		