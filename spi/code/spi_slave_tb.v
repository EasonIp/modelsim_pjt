/********************************Copyright**************************************                           
    **----------------------------File information--------------------------
    ** File name  :spi_slave_tb.v  
    ** CreateDate :2015.04
    ** Funtions   :测试文件
    ** Operate on :M5C06N3L114C7
    ** Copyright  :All rights reserved. 
    ** Version    :V1.0
    **---------------------------Modify the file information----------------
    ** Modified by   :
    ** Modified data :        
    ** Modify Content:
    *******************************************************************************/
  
    `timescale 1 ns/1 ns
    
    module  spi_slave_tb ;
       reg          clk;
         reg          rst_n;
         
         reg           spi_cs;
         reg           spi_sck;
         wire          spi_miso;
         reg           spi_mosi;
         
         wire          spi_over;
    
    spi_slave_2  spi_slave_2_1(
                                 .clk,
                                 .rst_n,
                                 
                                 .spi_cs,
                                 .spi_sck,
                                 .spi_miso,
                                 .spi_mosi,
                                 
                                 .spi_over
                                     );

     parameter tck = 24;
     parameter t = 1000/tck;
     
     always 
       #(t/2) clk = ~clk;
    
     
     //-------------------------------
  /* 模仿spi主机的发送程序，这个task很好，仿顺序操作，可以直观的显示过程 */
    task  spi_sd;
    input [7:0]  data_in;
    begin
    #(5*t);
        
        spi_sck = 0; spi_mosi= data_in[7]; #(5*t);    spi_sck = 1; #(5*t);    //send bit[7]
        spi_sck = 0; spi_mosi= data_in[6]; #(5*t);    spi_sck = 1; #(5*t);    //send bit[6]
        spi_sck = 0; spi_mosi= data_in[5]; #(5*t);    spi_sck = 1; #(5*t);    //send bit[5]
        spi_sck = 0; spi_mosi= data_in[4]; #(5*t);    spi_sck = 1; #(5*t);    //send bit[4]
        spi_sck = 0; spi_mosi= data_in[3]; #(5*t);    spi_sck = 1; #(5*t);    //send bit[3]
        spi_sck = 0; spi_mosi= data_in[2]; #(5*t);    spi_sck = 1; #(5*t);    //send bit[2]
        spi_sck = 0; spi_mosi= data_in[1]; #(5*t);    spi_sck = 1; #(5*t);    //send bit[1]
        spi_sck = 0; spi_mosi= data_in[0]; #(5*t);    spi_sck = 1; #(5*t);    //send bit[0]
      spi_sck = 0;
             
        end
    endtask
    
    
    initial 
      begin
       clk = 0;
         rst_n = 0;
         spi_cs = 1;
         spi_sck = 0;
       spi_mosi = 1;
         
         #(20*t) rst_n = 1; 
         #(10*t);
          spi_cs = 0;
          spi_sd(8'h81);
          #(50*t);
          spi_sd(8'h04);
            #(50*t);
             #(50*t);
          spi_cs = 1;
            
            #(20*t);
          spi_cs = 0;                
           spi_sd(8'h01);
            #(50*t);
           spi_sd(8'h00);
          #(50*t);
          spi_cs = 1;
      end
    
    
    
    
    endmodule