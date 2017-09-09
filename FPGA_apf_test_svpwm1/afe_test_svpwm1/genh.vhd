library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;

entity genh is 
  port(
         clk:in std_logic;
		 datain : in std_logic_vector(15 downto 0);
		 dataout : out std_logic_vector (15 downto 0)
       );
end ;
architecture arch of genh is 
signal a: std_logic_vector (15 downto 0) :="0000011011101110";--1774=1.732*1024
signal b: std_logic_vector (31 downto 0); 
signal b1: std_logic_vector (31 downto 0);
begin
  process(clk)
    begin
	   if clk'event and clk='1' then
		   b<=datain*a;--输入数据乘以1774
	   end if;
  end process;
  
  process(clk)
     begin
	   if clk'event and clk='1' then
	       b1<="0000000000"&b(31 downto 10);
	   end if;
  end process;
  
  process(clk)
   begin
	  if clk'event and clk='1' then
	     dataout<=b1(15 downto 0);
	  end if;
  end process;
  
  end;
	  
	  
	  
  
  
		  
		 
	    