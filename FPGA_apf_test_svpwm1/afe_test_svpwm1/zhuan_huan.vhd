library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;
entity zhuan_huan is 
  port(
         clk  :in std_logic;
         a,b: in signed(15 downto 0);
		 ua,ub: out std_logic_vector(15 downto 0)

       );
  end ;
architecture zhuan_huan of zhuan_huan is
signal ua_1,ub_1:signed (15  downto 0);
signal cnt      : integer range 0 to 1000;
begin 
   process(clk)
    begin 
        if clk'event and clk='1' then
         ua_1<=a-800;
         ub_1<=b-800;
        end if;
  end process;
 
  process(clk)
    begin
    if clk'event and clk='1' then
        ua<=conv_std_logic_vector (ua_1,16);
        ub<=conv_std_logic_vector (ub_1,16);
    end if;
  end process;
  


end;