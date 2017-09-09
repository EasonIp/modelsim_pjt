module FSM(clk,rst,in,out);
input clk,rst;
input [7:0] in;
output [7:0] out;

parameter [1:0] //synopsys enum code
START = 2'd0,
SA = 1,
SB = 2,
SC = 3;

reg [1:0] CS,NS;
reg [7:0] tmp_out,out;

// state transfer
always @ (posedge clk or negedge rst)
begin
if (!rst) CS <= #1 START;
else      CS <= #1 NS;
end

// state transfer discipline
always @ (in or CS)
begin
    NS = START;
    case (CS)
       START: case (in[7:6])
                       2'b11: NS = SA;
                       2'b00: NS = SC;
                       default: NS = START;
                       endcase
       SA: if(in == 8'h3c) NS = SB;
       SB: begin
                if (in == 8'h88) NS = SC;
                else             NS = START;
                end
       SC: case(1'b1) //synopsys parallel_case full_case
                (in == 8'd0): NS = SA;
                (8'd0 < in && in < 8'd38): NS = START;
                (in > 8'd37): NS = SB;
                  endcase
       endcase
end

// temp out
always @ (CS)
begin
    tmp_out = 8'bX;
    case (CS)
       START: tmp_out = 8'h00;
       SA:   tmp_out = 8'h08;
       SB:   tmp_out = 8'h18;
       SC:   tmp_out = 8'h28;
    endcase
end

// reg out
always @ (posedge clk or negedge rst)
begin
    if (!rst) out <= #1 8'b0;
    else     out <= #1 tmp_out;
end

endmodule