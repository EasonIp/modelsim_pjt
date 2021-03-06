
module sys_ctrl(
				clk,rst_n,sys_rst_n,
				clk_25_175m,clk_40m
			);

input clk;		//FPAG输入时钟信号25MHz
input rst_n;	//FPGA输入复位信号

output sys_rst_n;	//系统复位信号，低有效
output clk_25_175m;		//PLL输出25MHz时钟
output clk_40m;		//PLL输出50MHz时钟

wire locked;		//PLL输出有效标志位，高表示PLL输出有效

//----------------------------------------------
//例化PLL产生模块
				
// my_pll	my_pll_inst (
// 	.areset ( pll_rst ),
// 	.inclk0 ( clk ),
// 	.c0 ( clk_25m ),
// 	.c1 ( clk_50m ),
// 	.locked ( locked )
// 	);
	mypll inst_mypll (
		.areset(pll_rst),
		.inclk0(clk), 
		.c0(clk_25_175m), 
		.c1(clk_40m), 
		.locked(locked));

//----------------------------------------------
//PLL复位信号产生，高有效
//异步复位，同步释放
wire pll_rst;	//PLL复位信号，高有效

reg rst_r1,rst_r2;



always @(posedge clk or negedge rst_n)
	if(!rst_n) rst_r1 <= 1'b1;
	else rst_r1 <= 1'b0;

always @(posedge clk or negedge rst_n)
	if(!rst_n) rst_r2 <= 1'b1;
	else rst_r2 <= rst_r1;

assign pll_rst = rst_r2;

//----------------------------------------------
//系统复位信号产生，低有效
//异步复位，同步释放
wire sys_rst_n;	//系统复位信号，低有效
wire sysrst_nr0;
reg sysrst_nr1,sysrst_nr2;

assign sysrst_nr0 = rst_n & locked;	//系统复位直到PLL有效输出

always @(posedge clk_40m or negedge sysrst_nr0)
	if(!sysrst_nr0) sysrst_nr1 <= 1'b0;
	else sysrst_nr1 <= 1'b1;

always @(posedge clk_40m or negedge sysrst_nr0)
	if(!sysrst_nr0) sysrst_nr2 <= 1'b0;
	else sysrst_nr2 <= sysrst_nr1;

assign sys_rst_n = sysrst_nr2;


endmodule

