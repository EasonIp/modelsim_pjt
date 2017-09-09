/********************************Copyright**************************************                           
**----------------------------File information--------------------------
** File name  :bintogry_tb.v  
** CreateDate :2015.04
** Funtions   : 测试
** Operate on :M5C06N3L114C7
** Copyright  :All rights reserved. 
** Version    :V1.0
**---------------------------Modify the file information----------------
** Modified by   :
** Modified data :        
** Modify Content:
*******************************************************************************/
 
 module  bintogry_tb;
 parameter width = 4;
 reg               clk;
 reg               rst_n;
 
 reg   [width-1:0] databin;
 
 wire  [width-1:0] datagry;
 
  bintogry bintogry_1 (
                                     .clk,
                                     .rst_n,
                                     
                                     .databin,
                                     .datagry
                                         );


  parameter tck = 24;
  parameter t = 1000/tck;
 
  always 
    #(t/2) clk = ~clk;

  initial 
      begin
          clk = 0;
            rst_n = 0;
            databin = 0;
            
            #(20*t)  rst_n = 1;
            #(20*t)  databin = 1;
            #(20*t)  databin = 2;
            #(20*t)  databin = 3;
            #(20*t)  databin = 4;
      end
    
endmodule