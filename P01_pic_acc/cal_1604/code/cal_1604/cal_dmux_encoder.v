`include "cal_head.v"

module cal_dmux_encoder(acc_sel, arb_res, dmux, cpu_write, acc_write_out);
	
	input acc_sel, arb_res, cpu_write, acc_write_out;
	output reg [1:0] dmux;
	
	always @ (*)
	begin
		casex({arb_res, cpu_write, acc_write_out, acc_sel})
			{`ARB_CPU, 1'b0, 1'bx, 1'b0} :	dmux = `DMUX_MEM;
			{`ARB_CPU, 1'b1, 1'bx, 1'b0} :	dmux = `DMUX_CPU;
			{`ARB_CPU, 1'b0, 1'bx, 1'b1} :	dmux = `DMUX_ACC;
			{`ARB_CPU, 1'b1, 1'bx, 1'b1} :	dmux = `DMUX_CPU;
			{`ARB_ACC, 1'bX, 1'b0, 1'b0} :	dmux = `DMUX_MEM;
			{`ARB_ACC, 1'bX, 1'b1, 1'b0} :	dmux = `DMUX_ACC;
			default : dmux = `DMUX_CPU;
		endcase
	end
	
endmodule
