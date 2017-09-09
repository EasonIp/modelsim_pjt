library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

entity genghao3 is 
  port(
       clk:in std_logic;
		 datain : in std_logic_vector(15 downto 0);
		 dataout : out std_logic_vector (15 downto 0)
       );
end ;

architecture arch of genghao3 is 
signal data: std_logic_vector (15 downto 0);
signal x2,x4,x64,x512,x2048: std_logic_vector(15 downto 0);
begin

   process(clk)
	begin
	   if clk'event and clk ='1' then
		   data<=datain;
		end if;
   end process;
   process(clk) --����2��֮1
	  begin
	    if clk'event and clk='1' then
	      x2<='0'&data(15 downto 1);
		 end if;
   end process;
	
   process(clk) --����4��֮1
	  begin
	    if clk'event and clk='1' then
	      x4<="00"&data(15 downto 2);
		 end if;
   end process;
	
   process(clk) --����64��֮1
   begin
	    if clk'event and clk='1' then
	      x64<="000000"&data(15 downto 6);
		 end if;
   end process;
	
   process(clk) --����512��֮1
	  begin
	    if clk'event and clk='1' then
	      x512<="000000000"&data(15 downto 9);
		 end if;
   end process;
	
   process(clk) --����2048��֮1,������Ʋ��޷�̫С���˲�����ʡȥ
	  begin
	    if clk'event and clk='1' then
	      x2048<="00000000000"&data(15 downto 11);
	    end if;
   end process;
	
	process(clk)
	begin
	   if clk'event and clk='1' then
		   dataout<=data+x2+x4-x64-x512-x2048;
	   end if;
   end process;
	
end;
	
   
		 
		 
		 
		 
		 
		 