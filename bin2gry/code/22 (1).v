/********************************Copyright**************************************                           
**----------------------------File information--------------------------
** File name  :grytobin.v  
** CreateDate :2015.04
** Funtions   :将格雷码转化为二进制码
** Operate on :M5C06N3L114C7
** Copyright  :All rights reserved. 
** Version    :V1.0
**---------------------------Modify the file information----------------
** Modified by   :
** Modified data :        
** Modify Content:
*******************************************************************************/
 
  module  grytobin  (
               clk,
               rst_n,
               
                         gry,
                         bin
                 );
     localparam width = 4;
     input          clk;
     input          rst_n;
     
     input   [width-1:0]  gry;
     output  [width-1:0]  bin;
     reg     [width-1:0]  bin; 
 //---------------------------
  reg   [width-1:0]  gry_1;  /* 寄存输入值 */ 
    always @(posedge clk or negedge rst_n)
     begin
      if(!rst_n)
       begin
            gry_1 <= 'd0;
        end
      else 
        begin
          gry_1 <= gry;
        end
      end 
    //--------------------------
 reg   [2:0]    state;
 reg   [width-1:0] n;
 reg            switchover;
 reg   [width:0] bin_1;   /* 扩展一位 */
 always @(posedge clk or negedge rst_n)
 begin
  if(!rst_n)
   begin
     state <= 0;
         n <= 0;
         switchover <= 0;
         bin_1 <= 'd0;
    end
  else 
    begin
     case(state) 
            'd0:
              begin
                     n <= 0;
                     bin_1 <= 'd0;
                    if(gry_1[width-1:0]!= gry)    
                      state <= 'd1;
                    else 
                        state <= 'd0;
                end
            'd1:
                 begin
                   bin_1[width-1-n] <= bin_1[width-n]^gry_1[width-1-n];  /* 当前位与上次运算结果异或 */
                     state <= 'd2;    
                    end
            'd2:
              begin
                    if(n==(width-1))
                     begin
                         n <= 0;
                         state <= 'd3;
                         switchover <= 1;
                      end
                    else 
                        begin
                            n <= n + 1;
                          state <= 'd1;                                    
                        end
                    end
                'd3:
                  begin
                     switchover <= 0;     
                     state <= 'd0;
                    end
                default:state <= 'd0;
            endcase
    end
  end
    
    
always @(posedge clk or negedge rst_n)
 begin
   if(!rst_n)
     begin
      bin <= 'd0;
      end
    else if(switchover) bin <= bin_1;
    else bin <= bin;
  end    
 
endmodule