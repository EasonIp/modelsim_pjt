`define green_delay  25
`define yellow_delay 5

module transp_light(e_west,s_north,clk,rst);
  input clk,rst;
  output [1:0] e_west,s_north;
  reg [1:0] e_west,s_north;
  
  parameter red = 2'b0,
            green = 2'b1,
            yellow = 2'b10;
  
  parameter S0=4'b0001,
            S1=4'b0010,
            S2=4'b0100,
            S3=4'b1000;
  
  
  reg [3:0]state;
  reg [3:0]next_state;
  always @(posedge clk)
    if(!rst)
      state<=S0;
    else
      state<=next_state;
      
  always @(state)
  begin
    e_west=green;
    s_north=red;
    case(state)
      S0: ;
      S1: e_west=yellow;
      S2: begin
            e_west=red;
            s_north=green;
          end
      S3: s_north=yellow;
    endcase 
  end
  always @(state)
  begin
    case(state)
      S0: begin
           repeat(`green_delay) @(posedge clk);
           next_state=S1;
         end
      S1: begin
           repeat(`yellow_delay) @(posedge clk);
           next_state=S2;
         end
      S2: begin
           repeat(`green_delay) @(posedge clk);
           next_state=S3;
         end
      S3: begin
           repeat(`yellow_delay) @(posedge clk);
           next_state=S0;
         end
      default: next_state=S0;
    endcase
  end
endmodule
