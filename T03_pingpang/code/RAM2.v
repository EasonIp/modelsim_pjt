// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module RAM2 (
	input	[7:0]  data_a,
	input	wren_a,
	input	[9:0]  address_a,
	input	[7:0]  data_b,
	input	[9:0]  address_b,
	input	wren_b,
	input	clock_a,
	input	clock_b,
	output	[7:0]  q_a,
	output	[7:0]  q_b
		);


wire [7:0] sub_wire0;
wire [7:0] sub_wire1;
wire [7:0] q_a = sub_wire0[7:0];
wire [7:0] q_b = sub_wire1[7:0];
altsyncram	altsyncram_component (
.wren_a (wren_a),
.clock0 (clock_a),
.wren_b (wren_b),
.clock1 (clock_b),
.address_a (address_a),
.address_b (address_b),
.data_a (data_a),
.data_b (data_b),
.q_a (sub_wire0),
.q_b (sub_wire1)
// synopsys translate_off
,
.aclr0 (),
.aclr1 (),
.addressstall_a (),
.addressstall_b (),
.byteena_a (),
.byteena_b (),
.clocken0 (),
.clocken1 (),
.rden_b ()
// synopsys translate_on
);
defparam
altsyncram_component.intended_device_family = "Cyclone II",
altsyncram_component.operation_mode = "BIDIR_DUAL_PORT",
altsyncram_component.width_a = 8,
altsyncram_component.widthad_a = 10,
altsyncram_component.numwords_a = 1024,
altsyncram_component.width_b = 8,
altsyncram_component.widthad_b = 10,
altsyncram_component.numwords_b = 1024,
altsyncram_component.lpm_type = "altsyncram",
altsyncram_component.width_byteena_a = 1,
altsyncram_component.width_byteena_b = 1,
altsyncram_component.outdata_reg_a = "UNREGISTERED",
altsyncram_component.outdata_aclr_a = "NONE",
altsyncram_component.outdata_reg_b = "UNREGISTERED",
altsyncram_component.indata_reg_b = "CLOCK1",
altsyncram_component.address_reg_b = "CLOCK1",
altsyncram_component.wrcontrol_wraddress_reg_b = "CLOCK1",
altsyncram_component.outdata_aclr_b = "NONE",
altsyncram_component.clock_enable_input_a = "BYPASS",
altsyncram_component.clock_enable_output_a = "BYPASS",
altsyncram_component.clock_enable_input_b = "BYPASS",
altsyncram_component.clock_enable_output_b = "BYPASS",
altsyncram_component.power_up_uninitialized = "FALSE";
endmodule