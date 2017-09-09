module key_debounce(
            clk,rst_n,
            key1_n,key2_n,key3_n,
               led_d1,led_d2,led_d3
            );

input   clk;    //主时钟信号，50MHz
input   rst_n;    //复位信号，低有效
input   key1_n,key2_n,key3_n;     //三个独立按键，低表示按下
output  led_d1,led_d2,led_d3;    //发光二极管，分别由按键控制

//---------------------------------------------------------------------------
reg[2:0] key_rst;  

always @(posedge clk  or negedge rst_n)
    if (!rst_n) key_rst <= 3'b111;
    else key_rst <= {key3_n,key2_n,key1_n};

reg[2:0] key_rst_r;       //每个时钟周期的上升沿将low_key信号锁存到low_key_r中

always @ ( posedge clk  or negedge rst_n )
    if (!rst_n) key_rst_r <= 3'b111;
    else key_rst_r <= key_rst;
   
//当寄存器key_rst由1变为0时，led_an的值变为高，维持一个时钟周期
wire[2:0] key_an = key_rst_r & ( ~key_rst);

//---------------------------------------------------------------------------
reg[19:0]  cnt;    //计数寄存器

always @ (posedge clk  or negedge rst_n)
    if (!rst_n) cnt <= 20'd0;    //异步复位
    else if(key_an) cnt <=20'd0;
    else cnt <= cnt + 1'b1;

reg[2:0] low_key;

always @(posedge clk  or negedge rst_n)
    if (!rst_n) low_key <= 3'b111;
    else if (cnt == 20'hfffff)     //满20ms，将按键值锁存到寄存器low_key中     cnt == 20'hfffff
      low_key <= {key3_n,key2_n,key1_n};
      
//---------------------------------------------------------------------------
reg  [2:0] low_key_r;       //每个时钟周期的上升沿将low_key信号锁存到low_key_r中

always @ ( posedge clk  or negedge rst_n )
    if (!rst_n) low_key_r <= 3'b111;
    else low_key_r <= low_key;
   
//当寄存器low_key由1变为0时，led_ctrl的值变为高，维持一个时钟周期
wire[2:0] led_ctrl = low_key_r[2:0] & ( ~low_key[2:0]);

reg d1;
reg d2;
reg d3;
 
always @ (posedge clk or negedge rst_n)
    if (!rst_n) begin
        d1 <= 1'b0;
        d2 <= 1'b0;
        d3 <= 1'b0;
      end
    else begin        //某个按键值变化时，LED将做亮灭翻转
        if ( led_ctrl[0] ) d1 <= ~d1;    
        if ( led_ctrl[1] ) d2 <= ~d2;
        if ( led_ctrl[2] ) d3 <= ~d3;
      end

assign led_d3 = d1 ? 1'b1 : 1'b0;        //LED翻转输出
assign led_d2 = d2 ? 1'b1 : 1'b0;
assign led_d1 = d3 ? 1'b1 : 1'b0;
 
endmodule