/********************************Copyright**************************************                           
    **----------------------------File information--------------------------
    ** File name  :spi_writeread.v  
    ** CreateDate :2015.04
    ** Funtions   : SPI作为主机向从机读写，读的时候要注意，总共为15个时钟，在最后一个写地址时钟的下降沿就开始读取数据，
                   若要在下一个时钟的下降沿读取数据则要根据需要修改程序。注：本程序先发送最高位，先接收最高位
    ** Operate on :M5C06N3L114C7
    ** Copyright  :All rights reserved. 
    ** Version    :V1.0
    **---------------------------Modify the file information----------------
    ** Modified by   :
    ** Modified data :        
    ** Modify Content:
    *******************************************************************************/
     

    module  spi_writeread (
                                             clk,
                                             rst_n,
                                             spi_re_en,
                                             spi_wr_en,
                                             spi_addr,
                                             spi_send_data,
                                             spi_read_data,
                                             
                                             spi_cs,
                                             spi_clk,
                                             spi_mi,
                                             spi_mo,
                                             spi_busy,
                                             spi_over                                         
                                                 );
     input          clk;
     input          rst_n;
     input          spi_re_en;    //接收使能
     input          spi_wr_en;    //发送使能
     input  [7:0]   spi_addr;     //待发送的地址
     input  [7:0]   spi_send_data;  //待发送的数据

     output         spi_cs;    //片选信号
     output         spi_clk;   //时钟信号
     input          spi_mi;    //主机从芯片读取的数据
     output         spi_mo;    //主机向芯片发送的数据
     output   reg        spi_over;   //spi操作完成
     output   reg [7:0]  spi_read_data;  //spi接收的数据，即读取的数据
     output   reg        spi_busy;      //spi忙信号

     reg        temp_cs;
     reg        temp_scl;
     reg        temp_mo;

     assign  spi_cs = temp_cs;
     assign  spi_clk = temp_scl;
     assign  spi_mo = temp_mo;


    reg             sendbit_over;   //字节发送完成标志
    reg             resbit_over;    //接收字节完成标志
    reg    [7:0]    res_data;       //接收的数据

    //*******************状态机***************************
     parameter   cnt_delay = 4;   //CS的延时时钟的计数（根据芯片决定）
     reg    [3:0]    state;              //状态机
     reg    [7:0]    send_data;         //待发送的移位数据寄存器
     reg    [7:0]    read_data;          //接收数据寄存器
     reg    [2:0]    delay;             //发送完成，延时到可以再次发送，然后待命
     reg             wr_flag;           //写操作标志
     reg             re_flag;           //读操作标志
     reg             send_en;
     reg             resive_en;
     
     always @(posedge clk or negedge rst_n)
     begin
        if(!rst_n)
         begin
                 temp_cs <= 1;                 
         
             state <= 4'd0;
             send_data <= 8'd0;    
             read_data <= 8'd0;
             delay <= 0;
             wr_flag <= 0;
             re_flag <= 0;
             spi_busy <= 0;
                 spi_over <= 0;
             resive_en <= 0;
             send_en <=0;
            end
        else 
            begin
                case(state)
                 4'd0:
                     begin
                             delay <= 0;
                             temp_cs <= 1;
                             send_data <= 8'd0;
                             read_data <= 8'd0;
                             wr_flag <= 0;
                             re_flag <= 0;
                             spi_busy <= 0;
                             spi_over <= 0;
                             resive_en <= 0;
                             send_en <=0;
                             if(spi_wr_en)       //写使能
                                    begin
                                        spi_busy <=1;
                                        state <= 4'd1;
                                        wr_flag <= 1;   //写操作标志置位高
                                    end
                                else if(spi_re_en)
                                 begin
                                        spi_busy <=1; 
                                        state <= 4'd1;
                                        re_flag <= 1;  //读操作标志置位高
                                    end
                            end
                    4'd1:                     
                        begin
                             temp_cs <= 0;       //拉低cs信号
                             state <= 4'd2;    
                            end
                 4'd2:                  //拉低时钟和数据输出线
                     begin        
                         if(sendbit_over)
                             begin
                                    send_en <=0; 
                                    if(wr_flag) 
                                     begin
                                        state <= 4'd3;     
                                     end
                                    else if(re_flag)
                                     begin
                                        state <= 4'd4;     
                                        resive_en <=1;      /* 接收使能置高 */                                    
                                     end    
                                    else 
                                     begin
                                        state <= 4'd0;                                        
                                     end
                                end
                            else
                                begin
                                    send_data <= spi_addr;   //将地址寄存，然后发送地址                     
                                    state <= 4'd2;    
                                    send_en <=1;      
                                end        
                     end
                4'd3:
                     begin
                             if(sendbit_over)
                             begin
                                    state <= 4'd5;     
                                    send_en <=0;  
                                end
                            else
                                begin
                                    send_data <= spi_send_data;   //将地址寄存，然后发送地址                     
                                    state <= 4'd3;    
                                    send_en <=1;      
                                end         
                        end
                    4'd4:
                        begin
                            if(resbit_over)
                             begin
                                    state <= 4'd5;     
                                    resive_en <=0;
                                    read_data <= res_data; 
                                end
                            else
                                begin                                                 
                                    state <= 4'd4;    
                                    resive_en <=1;      
                                end         
                        end
                        4'd5:
                             begin
                                    temp_cs <= 1;
                                 if(delay == cnt_delay)
                                    begin
                                        state <= 4'd6;
                                        delay <= 0;
                                        spi_over <= 1; 
                                     end
                                    else 
                                        delay <= delay + 1;
                                    end
                            4'd6:
                                begin
                                    spi_over <= 0; 
                                    spi_busy <= 0;
                                    state <= 4'd0;
                                    end
                 default :  state <= 4'd0;                     
             endcase
         end
    end

    always @(posedge clk or negedge rst_n)
     begin
        if(!rst_n)
         begin
             spi_read_data <= 8'd0;
            end
        else 
            begin
                if(spi_over)
                    spi_read_data <= read_data;
                else 
                    spi_read_data <= spi_read_data;
            end
        end                 
     

    //****************发送****************
    reg    [3:0]   send_state;
    reg    [7:0]   shift_data;
    reg    [3:0]   send_num;

    reg    [3:0]    resive_state;
    reg    [2:0]    res_num;


    always @(posedge clk or negedge rst_n)
     begin
        if(!rst_n)
         begin
                temp_scl <= 0;             //模式0状态，数据、时钟都为低电平
                temp_mo  <= 0;
                
                shift_data <= 0;
                send_num <= 0;

                send_state<= 0;
                sendbit_over <= 0;
                
                resive_state <= 0;
                res_data <= 8'd0;
                res_num <= 0;
                resbit_over <= 0;
                
            end
        else if(send_en)
            begin
             case(send_state)
                4'd0:
                     begin    
                             temp_scl <= 0;
                             temp_mo <= 0;
                             send_num <= 4'd0;
                             shift_data <= send_data; 
                             send_state <= 4'd1;
                             sendbit_over <= 0;
                            end
                4'd1:
                     begin
                        temp_mo <=  shift_data[7] ;    /* 先发最高位，再发最低位 */          
                        send_state <= 4'd2;                              
                    end
                4'd2:
                    begin
                        temp_scl <= 1;                                 
                        send_state <= 4'd3;    
                    end
                4'd3:
                     begin
                            if(send_num == 4'd7)
                                begin
                                    send_state <= 4'd5;
                                    sendbit_over <= 1; 
                                    send_num <= 4'd0;
                                end
                            else
                                begin
                                    send_state <= 4'd4;  
                                end                         
                        end
                4'd4:
                    begin
                        temp_scl <= 0;
                        shift_data <= shift_data << 1;
                        send_num <= send_num + 1;    
                        send_state <= 4'd1; 
                     end

                4'd5:
                         begin
                             send_state <= 4'd5;  
                             sendbit_over <= 0;
                            end
                default: send_state <= 4'd0;
             endcase           
            end
        else if(resive_en)
                begin
                    case(resive_state)
                        'd0:
                            begin                           
                                 resive_state <= 4'd1;
                                 res_num <= 0;                        
                                 resbit_over <= 0;
                                end
                        'd1: 
                             begin
                                 temp_scl <= 0;        
                                 res_data[0] <= spi_mi;      /* 接收最低位，然后左移，故实际是先接收最高位 */
                                 resive_state <= 4'd2;                                                                       
                                end
                        'd2: 
                             begin
                                if(res_num == 4'd7)    
                                    begin
                                        resive_state <= 4'd5;    
                                        res_num <= 4'd0;
                                    end
                                else
                                 begin
                                    res_data <= res_data << 1;
                                    resive_state <= 4'd3;    
                                 end                                                                       
                                end        
                        'd3:
                            begin
                                    temp_scl <= 1;
                                    resive_state <= 4'd4;                                 
                            end
                        'd4:
                            begin
                                res_num <= res_num + 1;
                                resive_state <= 4'd1;    
                                end
                        'd5:
                            begin
                                 resbit_over <= 1;    
                                 resive_state <= 4'd6;    
                                end
                        'd6:
                            begin
                                resbit_over <= 0;    
                                resive_state <= 4'd6;        
                            end
                    default: resive_state <= 4'd0;    
                endcase
            end    
        else 
                begin                    
                    temp_scl <= 0;
                    temp_mo <= 0;
                    
                    shift_data <= 0;
                    send_num <= 0;
                    sendbit_over <= 0;    
                    send_state<= 0;
                    
                    resive_state <= 4'd0;
                    res_data <= 8'd0;
                    res_num <= 0;
                    resbit_over <= 0;        
             end
     end

    endmodule