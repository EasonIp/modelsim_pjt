/********************************Copyright**************************************                           
**----------------------------File information--------------------------
** File name  :spi_slave_send.v  
** CreateDate :2015.04
** Funtions   :FPGA作为从机在接收主机发来的地址信号时，输出数据信号，同时还接收主机发来的地址数据（全双工），一直到CS线拉高，没有信号再从主机中发出。
               数据地址都为8bit，spi的时钟在发送完8位之后最好能够间隔一下再发生另外8个时钟   
** Operate on :M5C06N3L114C7
** Copyright  :All rights reserved. 
** Version    :V1.0
**---------------------------Modify the file information----------------
** Modified by   :
** Modified data :        
** Modify Content:
*******************************************************************************/
 
 module  spi_slave (
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
 
 input           spi_cs;
 input           spi_sck;
 output          spi_miso;
 input           spi_mosi;
 
 output          spi_over;

//-----------------------------
 wire   [7:0]    rdata;
 wire            rover;
 wire            txd_en;
 wire   [7:0]    txd_data;
 wire            txd_over;
  spi_slave_rxd  spi_slave_rxd_1(
                                 .clk(clk),
                                 .rst_n(rst_n),
                       
                                 .spi_cs(spi_cs),
                                 .spi_sck(spi_sck),
                                 .spi_miso(),
                                 .spi_mosi(spi_mosi),
                                 
                                 .rdata_out(rdata),
                                 .rover(rover)
                                     );

  data_read  data_read_1(
                   .clk(clk),
                                 .rst_n(rst_n),
                                        
                                 .rover(rover),
                                 .rdata(rdata),
                                         
                                  .txd_en(txd_en),
                                 .txd_data(txd_data)
                                        
                                        );
  spi_slave_txd  spi_slave_txd_1(
               .clk(clk),
               .rst_n(rst_n),
               
                         .txd_en(txd_en),
                         .txd_data(txd_data),
                         
                         .spi_cs(spi_cs),
                         .spi_sck(spi_sck),
                         .spi_mosi(spi_mosi),
                         .spi_miso(spi_miso),
                         
                         .spi_over(spi_over),
                         .txd_over(txd_over)
                 );



endmodule