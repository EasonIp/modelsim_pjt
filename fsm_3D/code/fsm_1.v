 //本例主要采用三段式状态机：在异步复位信号的控制下，一段式状态机进入IDLE
 //状态，q_sig4被复位，一旦sig1或者sig2有效，状态机进入WAIT状态，如果sig1和sig2同时有效，那么
 //状态机进入DONE状态，如果sig4还有效，那么q_sig4置位，同时状态机进入IDLE状态。
 
 module three_seg_fsm(clk,reset,sig1,sig2,sig3,q_sig4);
 //数据声明部分
 input clk,reset,sig1,sig2,sig3;
 
 output reg       q_sig4;
 
 reg [1:0]    current_state, next_state;
 
 //参数声明
 parameter  IDLE       = 2'b00;
 parameter  WAIT       = 2'b01;
 parameter  DONE       = 2'b10;
 
 //状态跳转程序设计
 always @(posedge clk or posedge reset)
  if(reset)
      current_state <= IDLE;
  else
      current_state <= next_state;
      
 //状态跳转输出
 always @(current_state or sig1 or sig2 or sig3)
   begin
       case(current_state)
       IDLE: begin
                              if(sig1 || sig2)
                                   begin
                                       next_state = WAIT;                                      
                                   end
                                  else
                                      begin
                                          next_state = IDLE;                                         
                                    end
                           end
                   WAIT: begin
                             if(sig2 && sig3)
                                 begin
                                     next_state = DONE;                                    
                               end
                             else
                                 begin
                                     next_state = WAIT;                                    
                               end
                          end       
                                     
                   DONE:begin
                            if(sig3)
                                begin
                                    next_state = IDLE;                                   
                                end
                            else
                                begin
                                    next_state = DONE;                                   
                                end
                           end
                    
                 default: begin
                              next_state = IDLE;                             
                            end
           endcase       
   end
   
   //逻辑输出
   always @(posedge clk or posedge reset)
     if(reset)
         q_sig4 <= 1'b0;
     else
         begin
             case(next_state)
                 IDLE,
                 WAIT: q_sig4 <= 1'b0;
                 DONE: q_sig4 <= 1'b1;
                 default: q_sig4 <= 1'b0;
           endcase
         end
         
 endmodule   