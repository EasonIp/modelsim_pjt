`include "cal_head.v"

module cal_amux(cpu_addr_out, acc_addr_out, amux, addr_bus);
	
	input [15:0] cpu_addr_out, acc_addr_out;
	input amux;
	output reg [15:0] addr_bus;
	
	always @ (*)
	begin
		case(amux)
			`AMUX_CPU :	addr_bus = cpu_addr_out;
			`AMUX_ACC :	addr_bus = acc_addr_out;
			default : addr_bus = cpu_addr_out;
		endcase
	end

endmodule
