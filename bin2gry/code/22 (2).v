/********************************Copyright**************************************                           
**----------------------------File information--------------------------
** File name  :grytobin_tb.v  
** CreateDate :2015.04
** Funtions   :测试文件
** Operate on :M5C06N3L114C7
** Copyright  :All rights reserved. 
** Version    :V1.0
**---------------------------Modify the file information----------------
** Modified by   :
** Modified data :        
** Modify Content:
*******************************************************************************/
 module  grytobin_tb;
 parameter width = 4;
 reg               clk;
 reg               rst_n;
 
 reg   [width-1:0] gry;
 
 wire  [width-1:0] bin;
 
  grytobin  grytobin_1 (
                                     .clk,
                                     .rst_n,
                                     
                                     .gry,
                                     .bin
                                         );


  parameter tck = 24;
  parameter t = 1000/tck;
 
  always 
    #(t/2) clk = ~clk;

  initial 
      begin
          clk = 0;
            rst_n = 0;
            gry = 0;
            
            #(20*t)  rst_n = 1;
            #(20*t)  gry = 1;
            #(20*t)  gry = 2;
            #(20*t)  gry = 3;
            #(20*t)  gry = 4;
      end
    
endmodule