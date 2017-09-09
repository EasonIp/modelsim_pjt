/********************************Copyright**************************************                           
**----------------------------File information--------------------------
** File name  :SPI_slave_rd.v  
** CreateDate :2015.04
** Funtions   :SPI的通信实验，FPGA作为从机，接收主机数据以及向主机发送数据
** Operate on :M5C06N3L114C7
** Copyright  :All rights reserved. 
** Version    :V1.0
**---------------------------Modify the file information----------------
** Modified by   :
** Modified data :        
** Modify Content:
*******************************************************************************/
 

  module  spi_slave_rxd  (
                                 clk,
                                 rst_n,
                       
                                 spi_cs,
                                 spi_sck,
                                 spi_miso,
                                 spi_mosi,
                                 
                                 rdata_out,
                                 rover
                                     );
     input          clk;
     input          rst_n;
     
     input         spi_cs;
     input         spi_sck;
     input         spi_mosi;
     output        spi_miso;
     
     output reg [7:0] rdata_out;
     output reg       rover;
 //---------------------------------------
   reg           spi_cs_0,spi_cs_1;  /* 延时两个时钟，配合检测时钟边沿 */
     reg           spi_sck_0,spi_sck_1;
     reg           spi_mosi_0,spi_mosi_1;
     wire          spi_sck_pos;
//     wire          spi_sck_neg;
     wire          spi_cs_pos;
     wire          spi_cs_neg;
     wire          spi_cs_flag;
     wire          spi_miso_flag;
     always @(posedge clk or negedge rst_n)
     begin
      if(!rst_n)
       begin
          {spi_cs_1,spi_cs_0} <= 2'b11;
                {spi_sck_1,spi_sck_0} <= 2'b00;
                {spi_mosi_1,spi_mosi_0} <= 2'b00;
        end
      else 
        begin
          {spi_cs_1,spi_cs_0} <= {spi_cs_0,spi_cs}; 
                {spi_sck_1,spi_sck_0} <= {spi_sck_0,spi_sck};
                {spi_mosi_1,spi_mosi_0} <= {spi_mosi_0,spi_mosi};
        end
      end
        assign  spi_sck_pos = ~spi_sck_1 &spi_sck_0;  /* 取上升沿 */
//        assign  spi_sck_neg = ~spi_sck_0 &spi_sck_1;  /* 取下降沿 */
      assign  spi_cs_pos  = ~spi_cs_1&spi_cs_0;      /* 取spi_cs上升沿，作为结束信号 */
        assign  spi_cs_neg  = ~spi_cs_0&spi_cs_1;    /* 取spi_cs下降沿，作为开始信号 */
      assign  spi_cs_flag = spi_cs_1;
        assign  spi_miso_flag = spi_mosi_1;
    //----------------------------------------------------------
    localparam  idel = 3'd0;
    localparam  rxd_sta = 3'd1;
    localparam  rxd_over = 3'd2;    
      reg  [3:0]   cnt;
      reg  [7:0]   rdata;
        reg  [2:0]   state;
        always @(posedge clk or negedge rst_n)
         begin
          if(!rst_n)
           begin
             cnt <= 0;
                 rdata <= 0;
                 state <= idel;
                 rover <= 0;
                 rdata_out <= 0;
            end
            else 
                begin
                    case(state)    
                     idel:
                       begin
                            cnt <= 0;
                      rdata <= 0;
                            rover <= 0;
                            rdata_out <= 0;
                            if(spi_cs_neg) 
                               state <= rxd_sta;
                             else 
                                 state <= idel;
                            end
                   rxd_sta:
                       begin
                                if(spi_cs_flag) 
                                  state <= idel;
                                 else 
                                     begin
//                                         if((cnt == 8)&&(spi_sck_neg))     /* 更严谨 */
                                         if((cnt == 8))      
                                           begin
                                                    cnt <= 0;
                                                    state <= rxd_over;
                                                    rdata_out <= rdata;
                                                    rover <= 1;
                                                end
                                          else 
                                              begin
                                                 if(spi_sck_pos)
                                                        begin
                                                         cnt <= cnt + 1;  /* 最后cnt=8 */    
                                                         rdata[4'd7 - cnt] <= spi_miso_flag;  /* 从最高位到最低位逐渐接收数据 */
                                                        end
                                                 else
                                                        begin
                                                            cnt <= cnt ;  
                                                            rdata <= rdata;                      
                                                        end     
                                            end                                         
                                        end
                            end
                     rxd_over:
                        begin
                                rover<= 0;    
                                state <= rxd_sta;    
                             end
                default :    state <= idel;         
             endcase
      end    
  end
    
//    assign rdata_out = rdata;
//          else if(!psi_cs_flag)
//            begin
//             if(spi_sck_pos)
//                  begin
//                         cnt <= cnt + 1;  /* 最后cnt=8 */    
//                         rdata[4'd7 - cnt] <= spi_miso_flag;  /* 从最高位到最低位逐渐接收数据 */
//                        end
//                 else
//                        begin
//                            cnt <= cnt ;  
//                          rdata <= rdata;                      
//                        end
//            end
//             else 
//                 begin
//                            cnt <= 0 ;  
//                          rdata <= rdata;          /* 注意：保持，不清除 */              
//                 end    
//          end
//            
//      //------------------------
//     always @(posedge clk or negedge rst_n)
//     begin
//      if(!rst_n)
//       begin
//          rdata_out <= 8'd0;
//                rover <= 0;
//        end
//      else if(spi_cs_pos)
//        begin
//              rdata_out <= rdata; /* 赋值 */
//                rover <= 1;         /* 置位 */
//        end
//        else 
//            begin
//              rdata_out <= rdata_out;  /* 注意：保持，不清除 */   
//                rover <= 0;        /* 清除 */
//        end
//      end
 
    endmodule