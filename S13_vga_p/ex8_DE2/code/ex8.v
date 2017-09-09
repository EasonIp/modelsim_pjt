
module ex8(
		clk,rst_n,
		vga_r,vga_g,vga_b,
		vga_hsy,vga_vsy,vga_clk,
		adv7123_blank_n,adv7123_sync_n
	);

input clk;
input rst_n;
output[7:0] vga_r;
output[7:0] vga_g;
output[7:0] vga_b;

output vga_hsy,vga_vsy;
output vga_clk;
output adv7123_blank_n;
output adv7123_sync_n;

//-----------------------------------------------------------
	//PLLģ������
wire sys_rst_n;	//ϵͳ��λ�źţ�����Ч
wire clk_25_175m;		//PLL���25MHzʱ��
wire clk_40m;		//PLL���50MHzʱ��


	sys_ctrl inst_sys_ctrl
		(
			.clk         (clk),
			.rst_n       (rst_n),
			.sys_rst_n   (sys_rst_n),
			.clk_25_175m (clk_25_175m),
			.clk_40m     (clk_40m)
		);

	
//-----------------------------------------------------------
	//vga_ctrlģ������
	vga_ctrl inst_vga_ctrl (
			.clk_25_175m     (clk_25_175m),
			.clk_40m         (clk_40m),
			.rst_n           (sys_rst_n),
			.vga_r           (vga_r),
			.vga_g           (vga_g),
			.vga_b           (vga_b),
			.vga_hsy         (vga_hsy),
			.vga_vsy         (vga_vsy),
			.vga_clk         (vga_clk),
			.adv7123_blank_n (adv7123_blank_n),
			.adv7123_sync_n  (adv7123_sync_n)
		);

	
endmodule

