library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

entity mul is 
  port(
       clk:in std_logic;
       a,b :in std_logic_vector (15 downto 0);
       dout:out std_logic_vector (15 downto 0)
       );
end ;

architecture mul of mul is
signal a1: std_logic_vector(15 downto 0):="0000000000011010";
signal a2: std_logic_vector(15 downto 0):="0000000000011010";
signal buf :std_logic_vector (31 downto 0);
begin
   process(clk)
	  begin
	    if clk'event and clk ='1' then
		    buf <=a1*a2;
		 end if;
   end process;
   process(clk)
	  begin
	    if clk'event and clk ='1' then
		    dout <=buf(15 downto 0);
		 end if;
   end process;
	
	
end;