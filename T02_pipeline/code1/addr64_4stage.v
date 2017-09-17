module	addr64_4stage(
input	clk, rst_n,
input	[63 : 0]	x, y,
output	[64 : 0]	sum
);

 

parameter	ADD_WIDTH = 5'd16;

 

//16bit add and 4 stages
//first stage registers
reg	[ADD_WIDTH : 0]	r1_r, r2_r;
reg	[ADD_WIDTH - 1 : 0]	r3_r, r4_r, r5_r, r6_r; //
//second stage registers
reg	[ADD_WIDTH : 0]	r3_r2, r2_r2;
reg	[ADD_WIDTH - 1 : 0]	r1_r2, r4_r2, r5_r2; //
//third stage registers
reg	[ADD_WIDTH : 0]	r3_r3, r4_r3;
reg	[ADD_WIDTH - 1 : 0]	r1_r3, r2_r3; //
//forth stage registers
reg	[ADD_WIDTH : 0]	r4_r4;
reg	[ADD_WIDTH - 1 : 0]	r1_r4, r2_r4, r3_r4; //

 


always @(posedge clk or negedge rst_n)	begin
if(!rst_n)	begin
r1_r <= 1'b0;
r2_r <= 1'b0;
r3_r <= 1'b0;
r4_r <= 1'b0;
r5_r <= 1'b0;
r6_r <= 1'b0;

 

end
else
begin
//use 4 stages pipline
//first stage: 
	r1_r <= x[15 : 0] + y[15 : 0];
	r2_r <= x[31 : 16] + y[31: 16]; 
	r3_r <= x[47 : 32];	//16b
	r4_r <= y[47 : 32];	//16b
	r5_r <= x[63 : 48];	//16b
	r6_r <= y[63 : 48];	//16b
	//second stage
	r1_r2 <= r1_r[15 : 0];
	r2_r2 <= r2_r + r1_r[16];
	r3_r2 <= r3_r + r4_r;
	r4_r2 <= r5_r;
	r5_r2 <= r6_r;
	//thrid stage
	r1_r3 <= r1_r2;
	r2_r3 <= r2_r2[15 : 0];
	r3_r3 <= r3_r2 + r2_r2[16];
	r4_r3 <= r4_r2 + r5_r2;
	//forth stage
	r1_r4 <= r1_r3;
	r2_r4 <= r2_r3;
	r3_r4 <= r3_r3;
	r4_r4 <= r4_r3 + r3_r3[16];
end	//rst_n else
 


end	//always
//

 

assign	sum = {r4_r4, r3_r4[15:0], r2_r4[15:0], r1_r4[15:0]};

 

 

 

endmodule