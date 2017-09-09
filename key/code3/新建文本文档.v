/********************************Copyright**************************************                           
   **----------------------------File information--------------------------
   ** File name  :key_function_3.v  
   ** CreateDate :2015.03
   ** Funtions   :按键的用法（三）：一个按键完成单击，长击，双击的作用。
   ** Operate on :M5C06N3L114C7
   ** Copyright  :All rights reserved. 
   ** Version    :V1.0
   **---------------------------Modify the file information----------------
   ** Modified by   :
   ** Modified data :        
   ** Modify Content:
   *******************************************************************************/
    
    module  key_function_3 (
                                    clk,
                                    rst_n,
                    
                                    key_6,
                                    
                                    led_S,
                              led_L,
                                    led_D
                                    
                                        );
    input          clk;
    input          rst_n;
    
    input          key_6;
    
    output         led_S;
    output         led_L;
    output         led_D;
    
   //--------------------------------------------
   /* 定时：100ms，2s */
     reg           count_en;
     localparam  t_1s = 25'd23999999;
       localparam  t_100ms = 22'd2399999;
040    //  localparam  t_1s = 25'd2399;         /* //测试使用 */
   //    localparam  t_100ms = 22'd239;       /* //测试使用 */
043      localparam  t_2s = 2'd2;
       
       reg      [24:0]      count;
    always @(posedge clk or negedge rst_n)
    begin
     if(!rst_n)
      begin
           count <= 0;
       end
     else if(count_en)
       begin
          if(count == t_1s)
                    count <= 0;
               else 
                   count <= count + 1;
       end
      else
             count <= 0;    
     end
    
    reg     [1:0]   count1;
    always @(posedge clk or negedge rst_n)
    begin
     if(!rst_n)
      begin
          count1 <= 0;
       end
     else if(count_en)
       begin
            if(count1 == t_2s)
                count1 <= 2'd2;
            else if(count == t_1s)
                 count1 <= count1 + 1;
       end
      else
             count1 <= 0;
     end
       
   //-------------------------------
    /* 取key_6的上升沿和下降沿   */
    reg    [2:0]    key_6_reg;
    wire            key_6_pos;
    wire            key_6_neg;
    always @(posedge clk or negedge rst_n)
    begin
     if(!rst_n)
      begin
          key_6_reg  <= 3'b111;
       end
     else 
       begin
          key_6_reg  <= {key_6_reg[1:0],key_6};
       end
     end
       assign  key_6_pos = (key_6_reg[2:1] == 2'b01);
       assign  key_6_neg = (key_6_reg[2:1] == 2'b10);
    
    //------------------------------
    /*  状态机 */
     reg   [2:0]   state;
     reg           key_S;
       reg           key_L;
       reg           key_D;
       always @(posedge clk or negedge rst_n)
        begin
         if(!rst_n)
          begin
              state <= 'd0;
                    count_en <= 0;
                    key_S <= 0;
                    key_L <= 0;
                    key_D <= 0;
           end
         else 
           begin
             case(state)
                    'd0:
                       begin
                              count_en <= 0;
                                key_S  <= 0;
                          key_L  <= 0;
                                key_D <= 0;
                         if(key_6_neg)          /* 按键按下  */ 
                                 state <= 'd1;
                               else
                                   state <= 'd0;
                        end
                       'd1:
                         begin
                               if(key_6_pos)            /* 按键释放   */      
                                   begin
                                         count_en  <= 0; 
                                           state <= 'd3;    
                                       end
                                else  if((key_6_reg == 3'b000)&&(count1 == t_2s))     /* 按键长击   */
                                    begin
                                           count_en  <= 0; 
                                           state <= 'd2;
                                           key_L <= 1;
                                           end
                               else 
                                   count_en  <= 1;
                           end        
                        'd2:
                          begin
                                key_L <= 0;     
                                if(key_6_pos)
                                     state <= 'd7; 
                                   else 
                                       state <= 'd2;
                            end
                       'd3:
                             begin
                           state <= 'd4;
                                end
                       'd4:                                                      /* 决定单击还是双击 */
                         begin
                               if((key_6_neg)&&((count1 == 0)&&(count < t_100ms)))       /* 双击 *//* 按键按下  */ 
                                 begin
                                        count_en  <= 0;
                                        state <= 'd6;          
                                        key_D <= 1;
                                       end
                                else if((count1 == 0)&&(count > t_100ms))             /* 单击 */
                                    begin
                                        count_en  <= 0;
                                        state <= 'd5;          
                                        key_S <= 1;                                          
                                    end
                                else 
                                  count_en  <= 1;                                    
                               end
                           'd5:
                             begin
                                   state <= 'd8;        
                                   key_S <= 0;                                                         
                               end
                           'd6:
                             begin                                       
                                   key_D <= 0;     
                                   if(key_6_pos)                                     /* 按键释放 */  
                                       state <= 'd8;    
                                   else 
                                       state <= 'd6;   
                                   end
                           'd8:
                             begin
                                     state <= 'd0;    
                                   end                                
                     default:state <= 'd0;
                   endcase
                   
           end
         end
198      reg  [2:0]    led;
       always @(posedge clk or negedge rst_n)
        begin
         if(!rst_n)
          begin
             led <= 3'b000;
           end
         else 
           begin
            if(key_S)
                     led[0]<= ~led[0];    
                else if(key_L)
                     led[1]<= ~led[1];
                else if(key_D)
                     led[2]<= ~led[2];
           end
         end
           
   //------------------------------
   assign {led_D,led_L,led_S} = led;
219    endmodule
221