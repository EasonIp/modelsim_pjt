library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--FPGA与dsp通讯
entity  main is
port(wr,re,clk : in std_logic;                                --读写使能（dsp->fpga），系统时钟
     data: inout std_logic_vector(15 downto 0);                  --数据线（双向）
     addr: in std_logic_vector(5 downto 0);                   --地址线（dsp->fpga）
     start,stop,tongbu: out std_logic;
     t1,t2,t3: out std_logic_vector(15 downto 0);
     fault: in std_logic_vector(15 downto 0);
     dspdead: out std_logic;
     OE_PWM:out std_logic;
     OE_OUT:out std_logic;
     rst:out std_logic
     );
end;

architecture main of main is
signal command: std_logic_vector(15 downto 0);
signal t1_buf,t2_buf,t3_buf,fault_buf: std_logic_vector(15 downto 0);
signal dspdie,dsp1,dsp2,dsp_dead: std_logic;
signal cnt: integer range 0 to 6000;
signal rst_cnt: integer range 0 to 15000000;
signal out_cnt: integer range 0 to 20000000;
type statetype is (idle,dengdai);
signal state_start : statetype :=idle;
signal state_stop : statetype :=idle;
signal state_fault: statetype :=idle;
signal state_tongbu: statetype :=idle;
signal cong_start,cong_stop,cong_tongbu:std_logic;
signal rst_buf:std_logic:='0';
signal buf_out:std_logic:='1';
signal re1,re2             : std_logic;
begin
process(clk)
begin
  if clk'event and clk='1' then
     re1<=re;
     re2<=re1;
     if re2='1' and re1='0' then
         fault_buf<=fault;
     end if;
  end if;
end process;

process(clk,wr,re)
   begin
     if clk'event and clk='1' then
       if re='1' and wr='0' then
            case addr is
                  when "000001" =>command<=data;-- qidong
                  
                  when "000010" =>command<=data;--tingzhi
                  when "000011" =>command<=data;--tongbu
                  when "010001" =>t1_buf<=data;
                  when "010010" =>t2_buf<=data;
                  when "010011" =>t3_buf<=data; 
                  when others =>null;
            end case;
       elsif re='0' and wr='1' then
            case addr is
                  when "100001" => data<=fault_buf; --guzhang                         
                  when others=> data<="ZZZZZZZZZZZZZZZZ";
            end case;
       else 
              data<="ZZZZZZZZZZZZZZZZ";
       end if;
     end if;
end process;


process(clk)--发送启动命令   
variable cnt : integer range 0 to 100:=0;
begin
    if clk'event and clk='1' then
      case state_start is
       when idle=>
         if (addr="000001" and command="0000000000000101") and dspdie='0'  then
             cong_start<='1';
             state_start<=dengdai;
             --ceshi11<='1';
         else
             cong_start<='0';
             state_start<=idle;
         end if;
       when dengdai=>
         if cnt=100 then
            cong_start<='0';
            state_start<=idle;
            cnt:=0;
         else
            cnt:=cnt+1;
            state_start<=dengdai;
         end if;
       when others=>state_start<=idle;
      end case; 
     end if;
end process;


process(clk)--发送停止命令   
variable cnt : integer range 0 to 100:=0;
begin
    if clk'event and clk='1' then
      case state_stop is
       when idle=>
         if (addr="000010" and command="0000000000000010") and dspdie='0' then
             cong_stop<='1';
             state_stop<=dengdai;
             --ceshi11<='0';
         else
             cong_stop<='0';
             state_stop<=idle;
         end if;
       when dengdai=>
         if cnt=100 then
            cong_stop<='0';
            state_stop<=idle;
            cnt:=0;
         else
            cnt:=cnt+1;
            state_stop<=dengdai;
         end if;
       when others=>state_stop<=idle;
      end case; 
     end if;
end process;

process(clk)---tongbu
variable cnt : integer range 0 to 100:=0;
begin
    if clk'event and clk='1' then
      case state_tongbu is
       when idle=>
         if (addr="000011" and command="0000000000000011") and dspdie='0' then
             cong_tongbu<='1';
             state_tongbu<=dengdai;
          
         else
             cong_tongbu<='0';
             state_tongbu<=idle;
         end if;
       when dengdai=>
         if cnt=100 then
            cong_tongbu<='0';
            state_tongbu<=idle;
            cnt:=0;
         else
            cnt:=cnt+1;
            state_tongbu<=dengdai;
         end if;
       when others=>state_tongbu<=idle;
      end case; 
     end if;
end process;

process(clk)   
begin
   if clk'event and clk='1' then
       dspdie<= wr and re;
   end if;
end process;

process(clk) 
begin
    if clk'event and clk='1' then
       dsp1<=dspdie;
       dsp2<=dsp1;
           if dsp2=not dsp1 then
              cnt<=0;
              dspdead<='0';
              dsp_dead<='0';
           else
              if cnt=6000 then
                 cnt<=cnt;
                 dspdead<='1';
                 dsp_dead<='1';
              else
                 cnt<=cnt+1;
              end if;
           end if;
    end if;
end process; 


process(clk)
begin
    if clk'event and clk='1' then
       t1<=t1_buf;
       t2<=t2_buf;
       t3<=t3_buf;
       start<=cong_start;
       stop <=cong_stop;
       tongbu<=cong_tongbu;
      if rst_cnt=15000000 then
        rst_buf<='1';
        rst_cnt<=15000000;
      else 
        rst_buf<='0';
        rst_cnt<=rst_cnt+1;
      end if;
      if out_cnt=20000000 and dsp_dead='0' then
       buf_out<='0';
       out_cnt<=20000000;
      else 
       buf_out<='1';
       out_cnt<=out_cnt+1;
      end if;
       rst<=rst_buf;
       OE_OUT<=buf_out;
       OE_PWM<='0';
      
        
    end if;
end process;


end;

  