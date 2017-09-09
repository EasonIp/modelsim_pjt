//--====================================================================================--
// THIS FILE IS PROVIDED IN SOURCE FORM FOR FREE EVALUATION, FOR EDUCATIONAL USE OR FOR 
// PEACEFUL RESEARCH.  DO NOT USE IT IN A COMMERCIAL PRODUCT . IF YOU PLAN ON USING THIS 
// CODE IN A COMMERCIAL PRODUCT, PLEASE CONTACT JUSTFORYOU200@163.COM TO PROPERLY LICENSE 
// ITS USE IN YOUR PRODUCT. 
// 
// Project      : Verilog Common Module
// File Name    : sync_fifo_ctrl.v
// Creator(s)   : justforyou200@163.com
// Date         : 2015/12/01
// Description  : A sync fifo ctrl
//
// Modification :
// (1) Initial design  2015-12-01
//
//
//--====================================================================================--

module SYNC_FIFO_CTRL
    (  
        clk           ,
        rst_n         ,
        fifo_wr_en    ,     
        fifo_rd_en    ,
        fifo_wr_data  ,  
        fifo_full     ,
        fifo_wr_err   ,
        fifo_empty    ,
        fifo_rd_err   ,
        fifo_data_cnt ,
        fifo_rd_data 
    );
 
//PARA   DECLARATION
parameter FIFO_DATA_WIDTH = 32   ; 
parameter FIFO_ADDR_WIDTH = 8    ; 

//INPUT  DECLARATION
input                           clk          ; //fifo clock 
input                           rst_n        ; //fifo clock reset (0: reset)
input                           fifo_wr_en   ; //fifo write enable(1: enable)

input                           fifo_rd_en   ; //fifo read enable(1: enable)
input   [FIFO_DATA_WIDTH-1:0]   fifo_wr_data ; //fifo write data

//OUTPUT DECLARATION
output                          fifo_full    ; //fifo full status
output                          fifo_wr_err  ; //fifo write error status
output                          fifo_empty   ; //fifo empty status
output                          fifo_rd_err  ; //fifo read error status
output  [FIFO_ADDR_WIDTH  :0]   fifo_data_cnt; //fifo valid data cnt
output  [FIFO_DATA_WIDTH-1:0]   fifo_rd_data ; //fifo read data

//INTER  DECLARATION
wire                            fifo_full    ; //fifo full status
wire                            fifo_wr_err  ; //fifo write error status
wire                            fifo_empty   ; //fifo empty status
wire                            fifo_rd_err  ; //fifo read error status
reg     [FIFO_ADDR_WIDTH  :0]   fifo_data_cnt; //fifo valid data cnt
reg     [FIFO_DATA_WIDTH-1:0]   fifo_rd_data ; //fifo read data
reg     [FIFO_ADDR_WIDTH-1:0]   fifo_wr_addr ; //fifo write addr
reg     [FIFO_ADDR_WIDTH-1:0]   fifo_rd_addr ; //fifo write addr

//FIFO MEMORY INSTANCE
reg [FIFO_DATA_WIDTH-1:0] fifo_mem [{(FIFO_ADDR_WIDTH){1'b1}}:0] ;
integer i ;

//--========================MODULE SOURCE CODE==========================--

//--=========================================--
// SRAM INSTANCE :
// You Can use Reg Memory or Memory model here;
// FIFO Wdata & FIFO Rdata;
//--=========================================--
always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
    begin
        for(i=0;i<= {(FIFO_ADDR_WIDTH){1'b0}};i=i+1)
        fifo_mem[i] <= {(FIFO_DATA_WIDTH){1'b0}} ;
    end
    else if (fifo_wr_en & (~ fifo_full))
        fifo_mem[fifo_wr_addr] <= fifo_wr_data ;         
end

always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fifo_rd_data <= {(FIFO_DATA_WIDTH){1'b0}} ;
    else if (fifo_rd_en & (~ fifo_empty))
        fifo_rd_data <= fifo_mem[fifo_rd_addr] ;         
end

//--=========================================--
// READ CONTROL :
// Read address increase when read enable AND
// Not empty;
//--=========================================--
always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fifo_rd_addr <= {(FIFO_ADDR_WIDTH){1'b0}} ;
    else if (fifo_rd_en & (~ fifo_empty))
        fifo_rd_addr <= fifo_rd_addr + 1'b1 ;         
end

//--=========================================--
// WRITE CONTROL :
// Write address increase when write enable AND
// Not full.
//--=========================================--
always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fifo_wr_addr <= {(FIFO_ADDR_WIDTH){1'b0}} ;
    else if (fifo_wr_en & (~ fifo_full))
        fifo_wr_addr <= fifo_wr_addr + 1'b1 ;         
end

//--=========================================--
// FIFO DATA CNT :
// Valid Write Only, increase data cnt;
// Valid Read Only, decrease data cnt;
//--=========================================--
always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fifo_data_cnt <= {(FIFO_ADDR_WIDTH + 1){1'b0}} ;
    else if (fifo_wr_en & (~ fifo_full) & (~(fifo_rd_en & (~fifo_empty)))) //Valid Write Only, increase data cnt;
        fifo_data_cnt <= fifo_data_cnt + 1'b1 ;   
    else if (fifo_rd_en & (~ fifo_empty) & (~(fifo_wr_en & (~fifo_full)))) //Valid Read Only, decrease data cnt;
        fifo_data_cnt <= fifo_data_cnt - 1'b1 ;     
end

//--=========================================--
// FIFO Status :
// 1. fifo_empty when cnt ==0 ;
// 2. fifo full when cnt == MAX ;
//--=========================================--
assign fifo_empty  = (fifo_data_cnt == 0 ) ;
assign fifo_rd_err = (fifo_data_cnt == 0 ) & fifo_rd_en ;

assign fifo_full   = (fifo_data_cnt == ({(FIFO_ADDR_WIDTH){1'b1}} +1) ) ;
assign fifo_wr_err = (fifo_data_cnt == ({(FIFO_ADDR_WIDTH){1'b1}} +1) ) & fifo_wr_en ;

endmodule