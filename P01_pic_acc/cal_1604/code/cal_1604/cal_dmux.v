`include "cal_head.v"

module cal_dmux(cpu_data_out, mem_data_out, acc_data_out, dmux, data_bus);
	
	input [7:0] cpu_data_out, mem_data_out, acc_data_out;
	input [1:0] dmux;
	output reg [7:0] data_bus;

	always @ (*)
	begin
		case(dmux)
			`DMUX_MEM : data_bus = mem_data_out;
			`DMUX_CPU :	data_bus = cpu_data_out;
			`DMUX_ACC :	data_bus = acc_data_out;
			default :	data_bus = cpu_data_out;
		endcase
	end

endmodule
