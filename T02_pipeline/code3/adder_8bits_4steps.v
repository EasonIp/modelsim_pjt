module adder_8bits_4steps(cin_a, cin_b, c_in, clk, c_out, sum_out);
    input [7:0] cin_a;
    input [7:0] cin_b;
    input c_in;
    input clk;
    output c_out;
    output [7:0] sum_out;
	 
	 reg c_out;
	 reg c_out_t1, c_out_t2, c_out_t3;
	 
	 reg [7:0] sum_out;
	 reg [1:0] sum_out_t1;
	 reg [3:0] sum_out_t2;
	 reg [5:0] sum_out_t3;
	 
	 always @(posedge clk) begin
		{c_out_t1, sum_out_t1} = {1'b0, cin_a[1:0]} + {1'b0, cin_b[1:0]} + c_in;
	 end
	 
	 always @(posedge clk) begin
		{c_out_t2, sum_out_t2} = {{1'b0, cin_a[3:2]} + {1'b0, cin_b[3:2]} + c_out_t1, sum_out_t1};
	 end
	 
	 always @(posedge clk) begin
		{c_out_t3, sum_out_t3} = {{1'b0, cin_a[5:4]} + {1'b0, cin_b[5:4]} + c_out_t2, sum_out_t2};
	 end
	 
	 always @(posedge clk) begin
		{c_out, sum_out} = {{1'b0, cin_a[7:6]} + {1'b0, cin_b[7:6]} + c_out_t3, sum_out_t3};
	 end


endmodule