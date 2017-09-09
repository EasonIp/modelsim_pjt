/********************************Copyright**************************************                           
**----------------------------File information--------------------------
** File name  :data_rom.v  
** CreateDate :2015.04
** Funtions   : 简单的数据读写存储程序，配合测试
** Operate on :M5C06N3L114C7
** Copyright  :All rights reserved. 
** Version    :V1.0
**---------------------------Modify the file information----------------
** Modified by   :
** Modified data :        
** Modify Content:
*******************************************************************************/
  module  data_rom  (
               clk,
               rst_n,
               
                         wr,
                         rd,
                         
                         addr,
                         data_in,
                         data_out
                 );
     input          clk;
     input          rst_n;
     
     input          wr;
     input          rd;
     input  [6:0]   addr;
     input  [7:0]   data_in;
     
     output reg [7:0]   data_out;
     
     reg  [7:0]  table_1   [7:0];
     wire [7:0]  table_2   [7:0];
     always @(posedge clk or negedge rst_n)
     begin
      if(!rst_n)
       begin
          table_1[7] <= 0;
                table_1[6] <= 0;
                table_1[5] <= 0;
                table_1[4] <= 0;
                table_1[3] <= 0;
                table_1[2] <= 0;
                table_1[1] <= 0;
                table_1[0] <= 0;
                data_out <= 0;
        end
      else if(wr)
        begin
          table_1[addr] <= data_in;
        end
        else if(rd)
           data_out <= table_1[addr];
        else 
            begin
          table_1[7] <= table_1[7];
                table_1[6] <= table_1[6];
                table_1[5] <= table_1[5];
                table_1[4] <= table_1[4];
                table_1[3] <= table_1[3];
                table_1[2] <= table_1[2];
                table_1[1] <= table_1[1];
                table_1[0] <= table_1[0];
                data_out <= data_out;
        end 
      end
        
    assign table_2[7] = table_1[7];    
    assign table_2[6] = table_1[6];    
    assign table_2[5] = table_1[5];    
    assign table_2[4] = table_1[4];    
    assign table_2[3] = table_1[3];    
    assign table_2[2] = table_1[2];    
    assign table_2[1] = table_1[1];    
    assign table_2[0] = table_1[0];    
    
    endmodule