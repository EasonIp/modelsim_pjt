library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all
use ieee.std_logic_1164.all;

entity jisuan_c is 
  port(
       clk:in std_logic;
		 datain ,ub: in std_logic_vector(15 downto 0);--输入为根号3ua和ub
		 c : out std_logic_vector (15 downto 0)
		 
       );
		 end ;

architecture arch of jisuan_c is
signal c1 : std_logic_vector (15 downto 0);
begin
   process(clk)
	  begin
	    if clk 'event and clk='1' then
		    c1<=datain+ub;
		 end if;
   end process;
	
	process(clk)
	 begin
	    if clk'event and clk='1' then
		    c<='0'&c1(15 downto 1);
		 end if;
	end process;
	
	end;
		     