`include "cal_head.v"

module cal_wmux(cpu_write, acc_write_out, wmux, write_bus);

	input cpu_write, acc_write_out;
	input wmux;
	output reg write_bus;
	
	always @ (*)
	begin
		case(wmux)
			`WMUX_CPU :	write_bus = cpu_write;
			`WMUX_ACC :	write_bus = acc_write_out;
			default : write_bus = cpu_write;
		endcase
	end

endmodule
