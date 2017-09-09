//Design Example for Application Note: Using DCFIFO for Data Transfer Between Two Asynchronous Clock Domain

`timescale 1 ps / 1 ps

module dcfifo_de_top(
	trclk,
	reset,
	rvclk,
	word_count,
	q
);

input	trclk;
input	reset;
input	rvclk;
output	[31:0] q;
output  [8:0] word_count;

wire	[7:0] rom_addr;
wire	fifo_rdempty;
wire	[31:0] fifo_in;
wire	fifo_rdreq;
wire	[31:0] rom_out;
wire	fifo_wrfull;
wire	fifo_wrreq;
wire	[31:0] fifo_out;
wire	ram_wren, ram_rden;
wire	[7:0] ram_addr;
wire	[31:0] ram_in;

//ROM at transmitting domain
rom256x32	myrom(
	.clock(trclk),
	.address(rom_addr),
	.q(rom_out));

//Read data from ROM and write into the DCFIFO at transmitting domain
write_control_logic wrctrl_logic(
	.clk_i(trclk),
	.reset_i(reset),
	.wrfull_i(fifo_wrfull),
	.data_i(rom_out),
	.wrreq_o(fifo_wrreq),
	//.transfer_done_o(transfer_done),
	.addr_o(rom_addr),
	.data_o(fifo_in));

//DCFIFO acts as the interface between the transmitting domain and receiving domain
dcfifo8x32	mydcfifo(
	.wrreq(fifo_wrreq),
	.wrclk(trclk),
	.rdreq(fifo_rdreq),
	.rdclk(rvclk),
	.data(fifo_in),
	.wrfull(fifo_wrfull),
	.rdempty(fifo_rdempty),
	.q(fifo_out),
	.aclr(reset));
	
//Read data from DCFIFO and writes into the RAM at receiving domain
read_control_logic	rdctrl_logic(
	.clk_i(rvclk),
	.reset_i(reset),
	.rdempty_i(fifo_rdempty),
	.data_i(fifo_out),
	.rdreq_o(fifo_rdreq),
	.wren_o(ram_wren),
	.rden_o(ram_rden),
	.addr_o(ram_addr),
	.word_count_o(word_count),
	.data_o(ram_in));
	
//Ram at recieving domain	
ram256x32	myram(
	.wren(ram_wren),
	.clock(rvclk),
	.address(ram_addr),
	.data(ram_in),
	.q(q),
	.aclr(reset),
	.rden(ram_rden));

endmodule
