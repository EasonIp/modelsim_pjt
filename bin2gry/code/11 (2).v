/********************************Copyright**************************************                           
**----------------------------File information--------------------------
** File name  :bintogry.v  
** CreateDate :2015.04
** Funtions   :二进制转格雷码
** Operate on :M5C06N3L114C7
** Copyright  :All rights reserved. 
** Version    :V1.0
**---------------------------Modify the file information----------------
** Modified by   :
** Modified data :        
** Modify Content:
*******************************************************************************/
 
 module  bintogry  (
           clk,
           rst_n,
           
                     databin,
                     datagry
             );
    localparam width = 4;
 input          clk;
 input          rst_n;
 
 input  [width-1:0] databin;
 
 output [width-1:0] datagry;
 reg    [width-1:0] datagry;
 //----------------------
 reg   [width:0] databin_1;    /* 输入数据寄存器，扩展多一位 */
 always @(posedge clk or negedge rst_n)
 begin
  if(!rst_n)
   begin
     databin_1 <= 0;
    end
  else 
    begin
      databin_1[width-1:0] <= databin;   /* 寄存下 */    
    end
  end
    
 //---------------------------
 reg   [2:0]    state;
 reg   [width-1:0] n;
 reg            switchover;
 reg   [width-1:0] datagry_1;
 always @(posedge clk or negedge rst_n)
 begin
  if(!rst_n)
   begin
     state <= 0;
         n <= 0;
         switchover <= 0;
         datagry_1 <= 'd0;
    end
  else 
    begin
     case(state) 
            'd0:
              begin
                     n <= 0;
                     datagry_1 <= 'd0;
                    if(databin_1[width-1:0]!= databin)    
                      state <= 'd1;
                    else 
                        state <= 'd0;
                end
            'd1:
                 begin
                     datagry_1[width-1-n] <= databin_1[width-n]^databin_1[width-1-n];  /* 当前位与左边一位异或 */
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
      datagry <= 'd0;
      end
    else if(switchover) datagry <= datagry_1;
    else datagry <= datagry;
  end    
 
endmodule