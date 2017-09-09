library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;

entity judge_section is 
  port(
         clk:in std_logic;
		 ub,genh3ua: in std_logic_vector(15 downto 0);--·Ö±ðÅÐ¶ÏA,B,C
		 section : out std_logic_vector(3 downto 0)
       );
end ;

architecture arch of judge_section is
signal s,s1 : std_logic_vector(3 downto 0);
signal x1,x2,x3 : std_logic_vector (15 downto 0);
type statetype is(idle ,a,b,c,d);
signal state : statetype :=idle;
begin
  process(clk)
     begin
       if clk'event and clk='1' then
           x1<=ub;
           x2<=genh3ua-ub;
           x3<=genh3ua+ub;
       end if;
  end process;
  
  
  process(clk)
    begin 
    if clk'event and clk='1' then
      case state is
        when idle =>
                 state<=a;
                 s<="0000";
        when  a =>
	        if x1>"0000000000000000" then
               s<=s+"0001";
	        end if;
	           state<=b;
	    when  b =>
	        if x2>"0000000000000000" then
               s<=s+"0010";
	        end if;
	           state<=c;
	    when  c =>
	        if x3<"0000000000000000" then
               s<=s+"0100";
	        end if;
	           state<=d;
	    when  d =>
	           s1<=s;
	           state<=idle;
	    when others =>state<=idle;
	  end case;
	end if;
   end process;
   
   process(clk)
     begin
        if clk'event and clk='1' then
          section<=s1;
        end if;
   end process;
   
   
   
  end ;