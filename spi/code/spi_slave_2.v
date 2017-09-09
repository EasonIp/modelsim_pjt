/********************************Copyright**************************************                           
**----------------------------File information--------------------------
** File name  :spi_slave_2.v  
** CreateDate :2015.004
** Funtions   :spi通信试验。FPGA作为从机，与主机进行通信。先接收主机发来的地址，再根据地址最高位来判断是读数据还是些数据，
               然后从机是接收数据还是送出数据。地址最高位为高则是读取数据，否则为写数据.上升沿接收数据，下降沿发送数据
** Operate on :M5C06N3L114C7
** Copyright  :All rights reserved. 
** Version    :V1.0
**---------------------------Modify the file information----------------
** Modified by   :
** Modified data :        
** Modify Content:
*******************************************************************************/
  module  spi_slave_2  (
                                 clk,
                                 rst_n,
                       
                                 spi_cs,
                                 spi_sck,
                                 spi_miso,
                                 spi_mosi,
                                 
                                 spi_over
                                 
                                 
                                 
                  );
     input          clk;
     input          rst_n;
     
     input          spi_cs;
     input          spi_sck;
     input          spi_mosi;
     
     output   reg      spi_miso;
     output         spi_over;
     
     //-----------------------------//
     reg        spi_cs_2,spi_cs_1;
     reg        spi_sck_2,spi_sck_1;
     reg        spi_mosi_2,spi_mosi_1;
     wire       spi_cs_pos;
     wire       spi_cs_flag;
     wire       spi_sck_neg;
     wire       spi_sck_pos;
     wire       spi_mosi_flag;
     always @(posedge clk or negedge rst_n)
     begin
      if(!rst_n)
       begin
        {spi_cs_2,spi_cs_1} <= 2'b11;
        {spi_sck_2,spi_sck_1} <= 2'b00;
            {spi_mosi_2,spi_mosi_1} <= 2'b00;
         end
      else 
        begin
         {spi_cs_2,spi_cs_1} <= {spi_cs_1,spi_cs};
         {spi_sck_2,spi_sck_1} <= {spi_sck_1,spi_sck};
             {spi_mosi_2,spi_mosi_1} <= {spi_mosi_1,spi_mosi}; 
        end
      end
        
        assign spi_cs_pos = ~spi_cs_2 &spi_cs_1;
        assign spi_cs_flag = spi_cs_2;
        assign spi_sck_neg = ~spi_sck_1&spi_sck_2;
        assign spi_sck_pos = ~spi_sck_2&spi_sck_1; 
        assign spi_mosi_flag = spi_mosi_2;
         
        assign spi_over = spi_cs_pos;
    //----------------------------------------//
     localparam idel       = 4'd0;
     localparam rxd_addr   = 4'd1;
     localparam jude_wr_rd = 4'd2;
     localparam rxd_data   = 4'd3;
     localparam rxd_over   = 4'd4;
     localparam txd_data   = 4'd5;
     localparam txd_over   = 4'd6;
     localparam end_sta    = 4'd7;
     
     reg    [3:0]     state;
     reg    [3:0]     cnt;
     reg    [7:0]     raddr;
     reg    [7:0]     rdata;
     reg    [7:0]     tdata;
     reg              rover_flag;
     reg              wover_flag;
     reg              rd_flag;
     wire  [7:0]      data_out;
     always @(posedge clk or negedge rst_n)
     begin
      if(!rst_n)
       begin
          state <= 4'd0;
                cnt <= 0;
                raddr <= 8'd0;
                rdata <= 8'd0;
                tdata <= 8'd0;
                rover_flag <= 0;
                wover_flag <= 0;
                rd_flag <= 0;
                spi_miso <= 1;
        end
      else if(!spi_cs_flag)
        begin
          case(state)
                 idel:
                   begin
                            state <= rxd_addr;
                            cnt <= 0;
                            raddr <= 8'd0;
                            rdata <= 8'd0;
                            tdata <= 8'd0; 
                            rover_flag <= 0;
                      wover_flag <= 0;
                            rd_flag <= 0;
                            spi_miso <= 1;
                         end
                    rxd_addr:
                      begin
                            if(cnt == 8)
                             begin
                               cnt <= 0;
                               state <= jude_wr_rd;
                                end
                            else if(spi_sck_pos)
                                begin
                                    cnt <= cnt + 1;
                                    raddr[7 - cnt[2:0]] <= spi_mosi_flag;
                                end
                         end
                jude_wr_rd:
                   begin
                            if(raddr[7] == 1)
                               state <= rxd_data;
                            else
                                 begin
                                   state <= txd_data;
                                     rd_flag <= 1;
                                    end
                         end
            rxd_data:
                begin
                        if(cnt == 8)
                             begin
                               cnt <= 0;
                               state <= rxd_over;
                                end
                         else if(spi_sck_pos)
                                begin
                                    cnt <= cnt + 1;
                                    rdata[7 - cnt[2:0]] <= spi_mosi_flag;
                                end                                
                     end
            rxd_over:
              begin
                     rover_flag <= 1;    
                     state <= end_sta;
                    end
            txd_data:
              begin
                    tdata <= data_out;
                    if(cnt == 8)
                         begin
                              cnt <= 0;
                              state <= txd_over;
                            end
                    else if(spi_sck_pos)
                        begin
                                cnt <= cnt + 1;
                                spi_miso <= tdata[7 - cnt[2:0]];
                            end                        
                 end
            txd_over:
              begin
                    wover_flag <= 1;    
                     state <= end_sta;    
                    end
            end_sta:
               begin
                     rover_flag <= 0;    
                     wover_flag <= 0;    
                     state <= end_sta;                              
                 end
            default:state <= 4'd0;
         endcase      
     end
    else 
            begin
            state <= 4'd0;
                cnt <= 0;
                raddr <= 8'd0;
                rdata <= 8'd0;
                tdata <= 8'd0;
                rover_flag <= 0;
                wover_flag <= 0;
                rd_flag <= 0;
                spi_miso <= 1;    
            end
 end
    
    
    
    data_rom  data_rom_1 (
                                 .clk(clk),
                                 .rst_n(rst_n),
                                 
                                 .wr(rover_flag),
                                 .rd(rd_flag),
                                 
                                 .addr(raddr[6:0]),
                                 .data_in(rdata),
                                 .data_out(data_out)
                                     );
    endmodule