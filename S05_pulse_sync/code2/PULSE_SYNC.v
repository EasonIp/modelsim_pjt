//--====================================================================================--
// THIS FILE IS PROVIDED IN SOURCE FORM FOR FREE EVALUATION, FOR EDUCATIONAL USE OR FOR
// PEACEFUL RESEARCH.  DO NOT USE IT IN A COMMERCIAL PRODUCT . IF YOU PLAN ON USING THIS
// CODE IN A COMMERCIAL PRODUCT, PLEASE CONTACT justforyou200@163.com TO PROPERLY LICENSE
// ITS USE IN YOUR PRODUCT.
//
// Project      : Verilog Common Module
// File Name    : pulse_sync.v
// Creator(s)   : justforyou200@163.com
// Date         : 2015/12/01
// Description  : A sample pulse sync
//
// Modification :
// (1) Initial design  2015-12-01
//
//
//--====================================================================================--
 
module PULSE_SYNC
    (
        src_clk     , //source clock
        src_rst_n   , //source clock reset (0: reset)
        src_pulse   , //source clock pulse in
        dst_clk     , //destination clock
        dst_rst_n   , //destination clock reset (0:reset)
        dst_pulse     //destination pulse out
    );
  
//PARA   DECLARATION
 
 
//INPUT  DECLARATION
input               src_clk     ; //source clock
input               src_rst_n   ; //source clock reset (0: reset)
input               src_pulse   ; //source clock pulse in
 
input               dst_clk     ; //destination clock
input               dst_rst_n   ; //destination clock reset (0:reset)
 
//OUTPUT DECLARATION
output              dst_pulse   ; //destination pulse out
 
//INTER  DECLARATION
reg                 src_state   ;
reg                 state_dly1  ;
reg                 state_dly2  ;
reg                 dst_state   ;
wire                dst_pulse   ;
 
//--========================MODULE SOURCE CODE==========================--
 
always @(posedge src_clk or negedge src_rst_n)
begin
    if(src_rst_n == 1'b0)
        src_state   <= 1'b0 ;
    else if (src_pulse)
        src_state   <= ~src_state ;
end
 
always @(posedge dst_clk or negedge dst_rst_n)
begin
    if(dst_rst_n == 1'b0)
        begin
            state_dly1  <= 1'b0 ;
            state_dly2  <= 1'b0 ;
            dst_state   <= 1'b0 ;
        end
    else
        begin
            state_dly1  <= src_state ;
            state_dly2  <= state_dly1;
            dst_state   <= state_dly2;
        end
end
 
assign dst_pulse = dst_state ^ state_dly2 ;
 
endmodule