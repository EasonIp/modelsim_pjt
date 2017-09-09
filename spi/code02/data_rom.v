/********************************Copyright**************************************                           
**----------------------------File information--------------------------
** File name  :data_rom.v  
** CreateDate :2015.04
** Funtions   : 简单 rom 文件
** Operate on :M5C06N3L114C7
** Copyright  :All rights reserved. 
** Version    :V1.0
**---------------------------Modify the file information----------------
** Modified by   :
** Modified data :        
** Modify Content:
*******************************************************************************/
 

 module  data_rom  (
              addr,
                            
                            data

             );
 input   [7:0]       addr;
 output  [7:0]       data;
 
// always @(*)
//    begin
//         case()
//         end
 assign data = addr + 1;

endmodule