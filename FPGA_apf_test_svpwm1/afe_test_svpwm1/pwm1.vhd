library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pwm1  is
port(clk: in std_logic;
     start,stop,fault_or,dspdead: in std_logic;
     pwmup,pwmvp,pwmwp : in std_logic;
     up,un,vp,vn,wp,wn : out std_logic
     --tt:out std_logic
      );
end;

architecture arch of pwm1 is
signal start1,start2,stop1,stop2,fault_or1,fault_or2,dspdead1,dspdead2: std_logic;
type statetype is(fengsuo,jiefeng);
signal state: statetype :=fengsuo;
--signal tm:std_logic;
begin
  process(clk)
   begin
     if clk'event and clk='1' then
      start1<=start;
      start2<=start1;
      stop1<=stop;
      stop2<=stop1;
      fault_or1<=fault_or;
      fault_or2<=fault_or1;
      dspdead1<=dspdead;
      dspdead2<=dspdead1;
        case state is
            when fengsuo =>
                up<='0';
                un<='0';
                vp<='0';
                vn<='0';
                wp<='0';
                wn<='0';
             if start2='0' and start1='1' and fault_or='0' and dspdead='0'then
                state<=jiefeng;
             else
                state<=fengsuo;
             end if;
   
            when jiefeng =>
                up<=pwmup;
                un<=not pwmup;
                vp<=pwmvp;
                vn<=not pwmvp;
                wp<=pwmwp;
                wn<=not pwmwp;
             if (stop2='0' and stop1='1') or (fault_or2='0' and fault_or1='1') or stop='1' or (dspdead1='1' and dspdead2='0') or dspdead='1'then
                state<=fengsuo;
             else
                state<=jiefeng;
             end if;
             --if (stop2='0' and stop1='1') then
               -- tm<=not tm;
             --end if;
            when others=>state<=fengsuo;
        end case;
     end if;
   end process;
--   process(clk)
--    begin
--     if(clk'event and clk='1') then
--     tt<=tm;
--     end if;
--   end process;
   
   
   
   end;
   
                