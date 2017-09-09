library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;--ÓÐ·ûºÅÊý
use ieee.std_logic_1164.all;
entity jisuan_abc is
  generic ( t  : std_logic_vector(15 downto 0) :="0000001111101000"--1000
			  );
  port(
         clk  :in std_logic;
         t1x,t2x: in std_logic_vector(15 downto 0);
		 fi1,fi3: in std_logic_vector (31 downto 0);
		 n    :in std_logic_vector(3 downto 0);
		 tcm1,tcm2,tcm3 : out std_logic_vector(15 downto 0)
       );
		 end ;

architecture arch of jisuan_abc is
signal f1,f2,f3,t1,t2 : std_logic_vector (15 downto 0);
signal ta,tb,tc,taz,tbz,tcz : std_logic_vector (15 downto 0);
begin

  process(clk)
    begin
	    if clk'event and clk='1' then
		    f1<=fi1(15 downto 0);
			f2<=t-t1x-t2x;
			f3<=fi3(15 downto 0);
		end if;
  end process;
  
	 process(clk)
	   begin
		   if clk'event and clk='1' then
			   if f2<"0000000000000000" then
                    t1<=f1;
					t2<=f3;
			   else
				    t1<= t1x;
					t2<= t2x; 
				end if;
			end if;
	 end process;
	 
	 process(clk)--Ëãtaz
	   begin
		    if clk'event and clk='1' then
            taz<=t-t1-t2;
			end if;
	 end process;
	 
	 process(clk)--Ëãta
	   begin
		   if clk'event and clk='1' then
            ta<="00"&taz(15 downto 2);
			end if;
	 end process;
	
	 process(clk)--Ëãtbz
	   begin
		   if clk'event and clk='1' then
			   tbz<='0'&t1(15 downto 1);
		   end if;
    end process;
	 
	 process(clk)--Ëãtb
	   begin
		   if clk'event and clk='1' then
			   tb<=ta+tbz;
		   end if;
    end process;
	 
	 process(clk)--Ëãtcz
	   begin
		   if clk'event and clk='1' then
			   tcz<='0'&t2(15 downto 1);
		   end if;
    end process;
	 
	 process(clk)--Ëãtc
	   begin
		   if clk'event and clk='1' then
			   tc<=tb+tcz;
		   end if;
    end process;
		   
	 process(clk)
	   begin
	    if clk'event and clk='1' then
	      case n is
		        when "0001" => tcm1<=tb;tcm2<=ta;tcm3<=tc;
			    when "0010" => tcm1<=ta;tcm2<=tc;tcm3<=tb;
		        when "0011" => tcm1<=ta;tcm2<=tb;tcm3<=tc;
		        when "0100" => tcm1<=tc;tcm2<=tb;tcm3<=ta;
		        when "0101" => tcm1<=tc;tcm2<=ta;tcm3<=tb;
	            when "0110" => tcm1<=tb;tcm2<=tc;tcm3<=ta;
		        when others =>null;
		   end case;
		  end if;
	 end process;
  
  end;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  