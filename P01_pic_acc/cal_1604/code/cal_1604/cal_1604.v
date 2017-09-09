`include "cal_head.v"

module cal_1604(clk, rst_n, cpu_data_out, cpu_addr_out, cpu_write, cpu_req, mem_data_out, 
	acc_data_out, acc_addr_out, acc_write_out, acc_req, acc_int);
		
	input clk, rst_n;
	output [7:0] cpu_data_out, mem_data_out, acc_data_out;
	output [15:0] cpu_addr_out, acc_addr_out;
	output cpu_write, cpu_req, acc_req, acc_write_out, acc_int;
	
	wire acc_int, arb_res;
	wire [7:0] data_bus;
	wire [15:0] addr_bus;
	wire write_bus;
	wire [1:0] dmux;
	wire amux, wmux;
	wire acc_sel;
	
	cal_cpu cpu_inst(
		.clk(clk), 
		.rst_n(rst_n), 
		.cpu_data_in(data_bus), 
		.acc_int(acc_int), 
		.arb_res(arb_res), 
		.cpu_data_out(cpu_data_out), 
		.cpu_addr_out(cpu_addr_out), 
		.cpu_write(cpu_write), 
		.cpu_req(cpu_req)
	);
	
	cal_mem mem_inst(
		.clk(clk), 
		.rst_n(rst_n),
		.mem_data_in(data_bus), 
		.mem_addr_in(addr_bus),
		.mem_write(write_bus), 
		.mem_data_out(mem_data_out)
	);
	
	cal_acc acc_inst(
		.clk(clk), 
		.rst_n(rst_n), 
		.acc_data_in(data_bus), 
		.arb_res(arb_res), 
		.acc_addr_in(addr_bus), 
		.acc_write_in(write_bus), 
		.acc_data_out(acc_data_out), 
		.acc_addr_out(acc_addr_out), 
		.acc_write_out(acc_write_out), 
		.acc_req(acc_req),
		.acc_int(acc_int)
	);
	
	cal_dmux dmux_inst(
		.cpu_data_out(cpu_data_out), 
		.mem_data_out(mem_data_out), 
		.acc_data_out(acc_data_out), 
		.dmux(dmux), 
		.data_bus(data_bus)
	);
	
	cal_amux amux_inst(
		.cpu_addr_out(cpu_addr_out), 
		.acc_addr_out(acc_addr_out), 
		.amux(amux), 
		.addr_bus(addr_bus)
	);
	
	cal_wmux wmux_inst(
		.cpu_write(cpu_write), 
		.acc_write_out(acc_write_out), 
		.wmux(wmux),
		.write_bus(write_bus)
	);
	
	cal_arbiter arbiter_inst(
		.clk(clk), 
		.rst_n(rst_n), 
		.cpu_req(cpu_req), 
		.acc_req(acc_req), 
		.arb_res(arb_res)
	);
	
	cal_acc_sel acc_sel_inst(
		.addr_bus(addr_bus), 
		.acc_sel(acc_sel)
	);

	cal_awmux_encoder awmux_encoder_inst(
		.arb_res(arb_res), 
		.amux(amux), 
		.wmux(wmux), 
		.cpu_write(cpu_write), 
		.acc_write_out(acc_write_out)
	);
	
	cal_dmux_encoder dmux_encoder_inst(
		.acc_sel(acc_sel), 
		.arb_res(arb_res), 
		.dmux(dmux), 
		.cpu_write(cpu_write), 
		.acc_write_out(acc_write_out)
	);
	
endmodule
