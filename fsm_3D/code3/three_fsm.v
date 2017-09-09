module three_fsm(clk,rst_n,a,z);  

    input clk;
    input rst_n;
    input [3:0]a;

    output reg [3:0]z;      

    reg [5:0] current_state;
    reg [5:0] next_state;    

    parameter S0 = 6'b00_0001;
    parameter S1 = 6'b00_0010;
    parameter S2 = 6'b00_0100;
    parameter S3 = 6'b00_1000;
    parameter S4 = 6'b01_0000;
    parameter S5 = 6'b10_0000;

    //第一个进程，同步时序always模块，格式化描述次态寄存器迁移到现态寄存器
    //相当于是一个D触发器

    always@(posedge clk or negedge rst_n)      
    begin          
        if(!rst_n)              
            current_state <= S0;        
        else
            current_state <= next_state;   
    end 

    //第二个进程，组合逻辑always模块，描述状态转移条件判断     

    always@(*)                     
     begin             
        case(current_state)                
         S0: next_state = (a==0)?S1:S0;            
         S1: next_state = (a==1)?S2:S1;            
         S2: next_state = (a==2)?S3:S1;     
         S3: next_state = (a==3)?S4:S0;         
         S4: next_state = (a==4)?S5:S1;       
         S5: next_state = (a==5)?S3:S1;       
         default: next_state = S0;          
        endcase    
     end 

    //第三个进程，同步时序always模块，格式化描述次态寄存器输出

    always@(posedge clk or negedge rst_n)       
    begin         
        if(!rst_n)    
            z = 0;      
        else     
            case(next_state) 
                S0: z = 0;
                S1: z = 0;
                S2: z = 0;    
                S3: z = 0;
                S4: z = 0;
                S5: z = 1;     
                default: z = 0;        
            endcase    
     end 

endmodule 