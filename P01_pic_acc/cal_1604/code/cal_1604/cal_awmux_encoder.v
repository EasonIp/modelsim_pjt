`include "cal_head.v"

module cal_awmux_encoder(arb_res, amux, wmux, cpu_write, acc_write_out);
	
	input arb_res;
	input cpu_write, acc_write_out;
	output reg amux, wmux;
	
	always @ (*)
	begin
		casex({arb_res, cpu_write, acc_write_out})
			{`ARB_CPU, 1'b0, 1'bx} : begin amux = `AMUX_CPU;  wmux = `WMUX_CPU; end
			{`ARB_CPU, 1'b1, 1'bx} : begin amux = `AMUX_CPU;  wmux = `WMUX_CPU; end
			{`ARB_CPU, 1'b0, 1'bx} : begin amux = `AMUX_CPU;  wmux = `WMUX_CPU; end
			{`ARB_CPU, 1'b1, 1'bx} : begin amux = `AMUX_CPU;  wmux = `WMUX_CPU; end
			{`ARB_ACC, 1'bx, 1'b0} : begin amux = `AMUX_ACC;  wmux = `WMUX_ACC; end
			{`ARB_ACC, 1'bx, 1'b1} : begin amux = `AMUX_ACC;  wmux = `WMUX_ACC; end
			default : begin amux = `AMUX_CPU;  wmux = `WMUX_CPU; end
		endcase
	end

endmodule
