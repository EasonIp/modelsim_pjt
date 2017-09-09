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
   process(clk) --计算2分之1
	  begin
	    if clk'event and clk='1' then
	      x2<='0'&data(15 downto 1);
		 end if;
   end process;
	
   process(clk) --计算4分之1
	  begin
	    if clk'event and clk='1' then
	      x4<="00"&data(15 downto 2);
		 end if;
   end process;
	
   process(clk) --计算64分之1
   begin
	    if clk'event and clk='1' then
	      x64<="000000"&data(15 downto 6);
		 end if;
   end process;
	
   process(clk) --计算512分之1
	  begin
	    if clk'event and clk='1' then
	      x512<="000000000"&data(15 downto 9);
		 end if;
   end process;
	
   process(clk) --计算2048分之1,如果调制波限幅太小，此步可以省去
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
	
   
		 
		 
		 
		 
		 
		 