module uart_tx_top(Clk,Rst_n,Rs232_Tx,key_in0,led);

	input Clk;
	input Rst_n;
	input key_in0;
	
	output Rs232_Tx;
	output led;
	
	reg send_en;
	reg [7:0]data_byte;
	wire key_flag0;
	wire key_state0;
	wire Tx_Done;
	
	reg [2:0] cnt;
	
	localparam 
		byte1 = "H",
		byte2 = "E",
		byte3 = "L",
		byte4 = "L",
		byte5 = "O",
		byte6 = "\n";
		
	uart_byte_tx uart_byte_tx(
		.Clk(Clk),
		.Rst_n(Rst_n),
		.data_byte(data_byte),
		.send_en(send_en),
		.baud_set(3'd0),
		
		.Rs232_Tx(Rs232_Tx),
		.Tx_Done(Tx_Done),
		.uart_state(led)
	);
	
	key_filter key_filter0(
		.Clk(Clk),
		.Rst_n(Rst_n),
		.key_in(key_in0),
		.key_flag(key_flag0),
		.key_state(key_state0)
	);
	
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)
		cnt <= 1'b0;
	else if(Tx_Done)
		cnt <= cnt + 1'b1;
	else if(key_flag0 & !key_state0)
		cnt <= 1'b0;
		
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)
		send_en <= 1'b0;
	else if(key_flag0 & !key_state0)
		send_en <= 1'b1;
	else if(Tx_Done &(cnt < 3'd5))
		send_en <= 1'b1;
	else
		send_en <= 1'b0;
		
	always@(*)
		case(cnt)
			3'd0:data_byte = byte1;
			3'd1:data_byte = byte2;
			3'd2:data_byte = byte3;
			3'd3:data_byte = byte4;
			3'd4:data_byte = byte5;
			3'd5:data_byte = byte6;
			default:data_byte = 0;
		endcase
		
endmodule
