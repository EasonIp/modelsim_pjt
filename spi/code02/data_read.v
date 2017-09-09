/********************************Copyright**************************************                           
**----------------------------File information--------------------------
** File name  :data_read.v  
** CreateDate :2015.04
** Funtions   : 因为接收完成标志只有一个时钟周期，所以需要马上寄存地址数据，并且地址读取待发送的数据，然后置位发送是能信号。
** Operate on :M5C06N3L114C7
** Copyright  :All rights reserved. 
** Version    :V1.0
**---------------------------Modify the file information----------------
** Modified by   :
** Modified data :        
** Modify Content:
*******************************************************************************/
 
   module data_read(
                      clk,
                                        rst_n,
                                        
                                        rover,
                                        rdata,
                                        
                                        txd_en,
                                        txd_data
                                        
                                        ); 

  input         clk;
    input         rst_n;
    
    input         rover;
    input  [7:0]  rdata;
    
    output        txd_en;
    output  [7:0] txd_data;
    
 //------------------------------//
 reg            r_over_1;
 reg   [7:0]    r_addr;
 always @(posedge clk or negedge rst_n)
 begin
  if(!rst_n)
   begin
     r_addr <= 0;
         r_over_1 <= 0;
    end
  else if(rover)
    begin
     r_addr <= rdata; 
         r_over_1 <= 1;
    end
    else if(txd_en)
       r_over_1 <= 0;
  end
    
 reg      r_over_1_1;
 reg    r_over_1_2;
 reg    r_over_1_3;
 always @(posedge clk or negedge rst_n)
 begin
  if(!rst_n)
   begin
      {r_over_1_3,r_over_1_2,r_over_1_1} <= 3'b000;
    end
  else 
    begin
      {r_over_1_3,r_over_1_2,r_over_1_1} <= {r_over_1_2,r_over_1_1,r_over_1}; 
    end
  end
 assign  txd_en =     ~r_over_1_3&r_over_1_2;
     
    
    data_rom data_rom_1(
                         .addr(r_addr),
                                             .data(txd_data)
                                             );
endmodule