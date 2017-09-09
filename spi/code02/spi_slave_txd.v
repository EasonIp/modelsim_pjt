/********************************Copyright**************************************                           
    **----------------------------File information--------------------------
    ** File name  :spi_slave_txd.v  
    ** CreateDate :2015.04
    ** Funtions   :FPGA作为从机的发送数据程序
    ** Operate on :M5C06N3L114C7
    ** Copyright  :All rights reserved. 
    ** Version    :V1.0
    **---------------------------Modify the file information----------------
    ** Modified by   :
    ** Modified data :        
    ** Modify Content:
    *******************************************************************************/
 
  module  spi_slave_txd  (
               clk,
               rst_n,
               
                         txd_en,
                         txd_data,
                         
                         spi_cs,
                         spi_sck,
                         spi_mosi,
                         spi_miso,
                         
                         spi_over,
                         txd_over
                 );
     input          clk;
     input          rst_n;
     
     input          txd_en;
     input  [7:0]   txd_data;
     input          spi_cs;
     input          spi_sck;
     input          spi_mosi;
     output   reg   spi_miso;
     
     output         spi_over;
     output   reg   txd_over;
     
     //----------------------------------
      reg        spi_cs_0,spi_cs_1;
        reg        spi_sck_0,spi_sck_1;
        wire       spi_sck_neg;
        wire       spi_over;
        wire       spi_cs_flag;
        always @(posedge clk or negedge rst_n)
         begin
          if(!rst_n)
           begin
             {spi_cs_1,spi_cs_0} <= 2'b11;
                 {spi_sck_1,spi_sck_0} <= 2'b00;
            end
          else 
            begin
             {spi_cs_1,spi_cs_0} <=  {spi_cs_0,spi_cs};
                 {spi_sck_1,spi_sck_0} <= {spi_sck_0,spi_sck};
            end
          end
        
        assign spi_cs_flag = spi_cs_1;
        assign spi_sck_neg = (spi_sck_1&(~spi_sck_0));
        assign spi_over  =     ~spi_cs_1&spi_cs_0;
     //---------------------------------------------//
     localparam   idel = 2'd0;
     localparam   txd_sta= 2'd2;
     localparam   txd_data_sta = 2'd1;
     reg     [1:0]  state;
     reg     [3:0]  cnt;
     reg     [7:0]  txdata;
     
    always @(posedge clk or negedge rst_n)
     begin
      if(!rst_n)
       begin
         state <= idel;
             cnt <= 0;
         txdata <= 0;
             spi_miso <= 1;   /* 拉高 */
      end
      else 
        begin
          case(state)
                 idel:
                   begin
                         cnt <= 0;
               txdata <= 0;
                         spi_miso <= 1;   /* 拉高 */
                         if(txd_en)     
                          begin
                                 state <= txd_data_sta;
                                 
                                end
                            else
                                begin
                                    state <= idel;    
                                end                                    
                      end
                    txd_data_sta:
                      begin
                                txdata <= txd_data;
                                state <= txd_sta;    
                                txd_over <=0;
                            end
                 txd_sta:
                     begin
                        if(spi_cs_flag )     
                             state <= idel;
                        else if(cnt == 8)
                          begin
                                cnt <= 0;    
                                txd_over <= 1;
                                state <= txd_data_sta;
                                end
                         else
                                begin
                                     if(spi_sck_neg)
                                         begin
                                             spi_miso <= txdata[7-cnt[2:0]] ; /* 先高位再低位传输 */
                                             cnt <= cnt +1;    /* 范围：0-8 */
                                            end
                                        else 
                                            begin
                                                spi_miso <= spi_miso; /* 保持 */
                                              cnt <= cnt;
                                            end
                                    end                                                     
                          end
                default:state <= idel;
             endcase    
        end
      end        
    
    endmodule