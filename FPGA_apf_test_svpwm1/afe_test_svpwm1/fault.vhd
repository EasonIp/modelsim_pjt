library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fault is
port(clk : in std_logic;
     fault_up,fault_un,fault_vp,fault_vn,fault_wp,fault_wn: in std_logic:='0';
     fault_or: out std_logic;
     fault : out std_logic_vector(15 downto 0)
     );
end;

architecture fault of fault is
signal fault_wn1:std_logic:='1';
signal fault_wn2:std_logic:='1';
signal fault_wp1:std_logic:='1';
signal fault_wp2:std_logic:='1';
signal fault_vn1:std_logic:='1';
signal fault_vn2:std_logic:='1';
signal fault_vp1:std_logic:='1';
signal fault_vp2:std_logic:='1';
signal fault_un1:std_logic:='1';
signal fault_un2:std_logic:='1';
signal fault_up1:std_logic:='1';
signal fault_up2:std_logic:='1';

signal fault_vn_buf:std_logic:='0';
signal fault_vp_buf:std_logic:='0';
signal fault_un_buf:std_logic:='0';
signal fault_up_buf:std_logic:='0';
signal fault_wn_buf:std_logic:='0';
signal fault_wp_buf:std_logic:='0';
signal fault_wn_cnt: integer range 0 to 500;
signal fault_wp_cnt: integer range 0 to 500;
signal fault_vn_cnt: integer range 0 to 500;
signal fault_vp_cnt: integer range 0 to 500;
signal fault_un_cnt: integer range 0 to 500;
signal fault_up_cnt: integer range 0 to 500;
begin

process(clk)
begin
   if clk'event and clk='1' then
       fault_wn1<=fault_wn;
       fault_wn2<=fault_wn1;
       if(fault_wn1='0' and fault_wn2='1') or fault_wn1='0'  then
        fault_wn_cnt<=fault_wn_cnt+1;
        if(fault_wn_cnt>5) then
        fault_wn_buf<='0';
        end if;
       else 
       fault_wn_cnt<=0;
       fault_wn_buf<='1';
       end if;      
   end if;
end process;

process(clk)
begin
   if clk'event and clk='1' then
       fault_wp1<=fault_wp;
       fault_wp2<=fault_wp1;
       if(fault_wp1='0' and fault_wp2='1') or fault_wp1='0'  then
        fault_wp_cnt<=fault_wp_cnt+1;
        if(fault_wp_cnt>5) then
        fault_wp_buf<='0';
        end if;
       else 
       fault_wp_cnt<=0;
       fault_wp_buf<='1';
       end if;      
   end if;
end process;

process(clk)
begin
   if clk'event and clk='1' then
       fault_vn1<=fault_vn;
       fault_vn2<=fault_vn1;
       if(fault_vn1='0' and fault_vn2='1') or fault_vn1='0'  then
        fault_vn_cnt<=fault_vn_cnt+1;
        if(fault_vn_cnt>5) then
        fault_vn_buf<='0';
        end if;
       else 
       fault_vn_cnt<=0;
       fault_vn_buf<='1';
       end if;      
   end if;
end process;

process(clk)
begin
   if clk'event and clk='1' then
       fault_vp1<=fault_vp;
       fault_vp2<=fault_vp1;
       if(fault_vp1='0' and fault_vp2='1') or fault_vp1='0'  then
        fault_vp_cnt<=fault_vp_cnt+1;
        if(fault_vp_cnt>5) then
        fault_vp_buf<='0';
        end if;
       else 
       fault_vp_cnt<=0;
       fault_vp_buf<='1';
       end if;      
   end if;
end process;

process(clk)
begin
   if clk'event and clk='1' then
       fault_un1<=fault_un;
       fault_un2<=fault_un1;
       if(fault_un1='0' and fault_un2='1') or fault_un1='0'  then
        fault_un_cnt<=fault_un_cnt+1;
        if(fault_un_cnt>5) then
        fault_un_buf<='0';
        end if;
       else 
       fault_un_cnt<=0;
       fault_un_buf<='1';
       end if;      
   end if;
end process;

process(clk)
begin
   if clk'event and clk='1' then
       fault_up1<=fault_up;
       fault_up2<=fault_up1;
       if(fault_up1='0' and fault_up2='1') or fault_up1='0' then
        fault_up_cnt<=fault_up_cnt+1;
        if(fault_up_cnt>5) then
        fault_up_buf<='0';
        end if;
       else 
       fault_up_cnt<=0;
       fault_up_buf<='1';
       end if;      
   end if;
end process;





process(clk)
begin
   if clk'event and clk='1' then
       fault<="0000000000"&(not fault_wn_buf)&(not fault_wp_buf)&(not fault_vn_buf)&(not fault_vp_buf)&(not fault_un_buf)&(not fault_up_buf);
       fault_or<=(not fault_wn_buf) or (not fault_wp_buf) or (not fault_vn_buf) or (not fault_vp_buf) or (not fault_un_buf) or (not fault_up_buf);  
   end if;
end process;

end;