`include "cal_head.v"

module cal_acc(clk, rst_n, acc_data_in, arb_res, acc_addr_in, acc_write_in, acc_data_out, 
	acc_addr_out, acc_write_out, acc_req, acc_int);
		
	input clk, rst_n;
	input [7:0] acc_data_in;
	input arb_res;
	input [15:0] acc_addr_in;
	input acc_write_in;
	output reg [7:0] acc_data_out;
	output reg [15:0] acc_addr_out;
	output reg acc_write_out, acc_req, acc_int;

	reg [15:0] ass, ast;
	reg [7:0] s_reg;
	reg [63:0] source64, target64;
	reg clear;
	reg [4:0] state;
	
	localparam s0 = 5'd0;
	localparam s1 = 5'd0;
	localparam s2 = 5'd0;
	localparam s3 = 5'd0;
	localparam s4 = 5'd0;
	localparam s5 = 5'd0;
	localparam s6 = 5'd0;
	localparam s7 = 5'd0;
	localparam s8 = 5'd0;
	localparam s9 = 5'd0;
	localparam s10 = 5'd0;
	localparam s11 = 5'd0;
	localparam s12 = 5'd0;
	localparam s13 = 5'd0;
	localparam s14 = 5'd0;
	localparam s15 = 5'd0;
	localparam s16 = 5'd0;
	localparam s17 = 5'd0;
	localparam s18 = 5'd0;
	localparam s19 = 5'd0;
	localparam s20 = 5'd0;
	localparam s21 = 5'd0;
	localparam s22 = 5'd0;
	localparam s23 = 5'd0;
	localparam s24 = 5'd0;
	localparam s25 = 5'd0;
	localparam s26 = 5'd0;
	localparam s27 = 5'd0;
	localparam s28 = 5'd0;
	localparam s29 = 5'd0;
	localparam s30 = 5'd0;
	
	always @ (posedge clk)
	begin : ass_node
		if(!rst_n)
			ass <= 0;
		else if(acc_write_in && (acc_addr_in == `ASSH))
			ass[15:8] <= acc_data_in;
		else if(acc_write_in && (acc_addr_in == `ASSL))
			ass[7:0] <= acc_data_in;
	end

	always @ (posedge clk)
	begin : ast_node
		if(!rst_n)
			ast <= 0;
		else if(acc_write_in && (acc_addr_in == `ASTH))
			ast[15:8] <= acc_data_in;
		else if(acc_write_in && (acc_addr_in == `ASTL))
			ast[7:0] <= acc_data_in;
	end
	
	always @ (posedge clk)
	begin : s_reg_node
		if(!rst_n)
			s_reg <= 0;
		else if(acc_write_in && (acc_addr_in == `S_REG))
			s_reg <= acc_data_in;
		
		if(clear)
			s_reg[7] <= 0;
	end



endmodule
