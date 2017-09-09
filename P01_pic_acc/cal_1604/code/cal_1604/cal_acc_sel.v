`include "cal_head.v"

module cal_acc_sel(addr_bus, acc_sel);

	input [15:0] addr_bus;
	output reg acc_sel;

	always @ (*)
	begin
		if((addr_bus & `ACC_MASK) == `ACC_BASE)
			acc_sel = 1;
		else 
			acc_sel = 0;
	end
	
endmodule 