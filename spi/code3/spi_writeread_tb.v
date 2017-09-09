/********************************Copyright**************************************                           
    **----------------------------File information--------------------------
    ** File name  :spi_writeread_tb.v  
    ** CreateDate :2015.04
    ** Funtions   : SP的测试文件
    ** Operate on :M5C06N3L114C7
    ** Copyright  :All rights reserved. 
    ** Version    :V1.0
    **---------------------------Modify the file information----------------
    ** Modified by   :
    ** Modified data :        
    ** Modify Content:
    *******************************************************************************/
     
  module  spi_writeread_tb;  
    
     reg          clk;
     reg          rst_n;
     reg          spi_re_en;    //接收使能
     reg          spi_wr_en;    //发送使能
     reg  [7:0]   spi_addr;     //待发送的地址
     reg  [7:0]   spi_send_data;  //待发送的数据 
     
     wire          spi_cs;    //片选信号
     wire          spi_clk;   //时钟信号
     reg           spi_mi;    //主机从芯片读取的数据
     wire          spi_mo;    //主机向芯片发送的数据
     wire          spi_over;   //spi操作完成
     wire   [7:0]  spi_read_data;  //spi接收的数据，即读取的数据
     wire          spi_busy;      //spi忙信号
     
     spi_writeread  spi_writeread_1(
                                             .clk(clk),
                                             .rst_n(rst_n),                 
                                             .spi_re_en(spi_re_en),
                                             .spi_wr_en(spi_wr_en),
                                             .spi_addr(spi_addr),
                                             .spi_send_data(spi_send_data),
                                             .spi_read_data(spi_read_data),
                                             
                                             .spi_cs(spi_cs),
                                             .spi_clk(spi_clk),
                                             .spi_mi(spi_mi),
                                             .spi_mo(spi_mo),
                                             .spi_busy(spi_busy),
                                             .spi_over(spi_over)                                         
                                                 );
                                                 
     parameter tck = 24;
     parameter t = 1000/tck;   
     
     always 
       #(t/2) clk = ~clk;     //25Ghz
    
     
     always 
       #(5*t) spi_mi = ~spi_mi;  
         
   initial 
      begin
        clk = 0;
        rst_n = 0;
            spi_re_en = 0;
            spi_wr_en = 0;
            spi_addr = 0;
            spi_send_data = 0;
            spi_mi = 0;
            
            #(10*t)  rst_n = 1;
            
             #(5*t)  spi_addr = 8'h55;
                    spi_send_data = 8'haa;
             #(2*t) spi_wr_en = 1;
             #(2*t) spi_wr_en = 0;
             
            #(100*t) ;
            #(5*t)  spi_addr = 8'h0f;
              #(2*t) spi_re_en = 1;
              #(2*t) spi_re_en = 0;
             
             
      end
        
                                                 
    
    endmodule