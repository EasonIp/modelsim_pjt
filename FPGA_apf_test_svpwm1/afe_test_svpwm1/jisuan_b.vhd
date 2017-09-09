library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;--有符号数
use ieee.std_logic_1164.all;

entity jisuan_b is 
  port(
       clk:in std_logic;
		 datain ,ub: in std_logic_vector(15 downto 0);--输入为根号3ua和ub
		 b : out std_logic_vector (15 downto 0)
		 
       );end ;

architecture arch of jisuan_b is
signal b1 : std_logic_vector (15 downto 0);
begin
   process(clk)
	  begin
	    if clk 'event and clk='1' then
		    b1<=datain-ub;
		 end if;
   end process;
	
	process(clk)
	 begin
	    if clk'event and clk='1' then
		    b<='0'&b1(15 downto 1);
		 end if;
	end process;
	
	end;
		     