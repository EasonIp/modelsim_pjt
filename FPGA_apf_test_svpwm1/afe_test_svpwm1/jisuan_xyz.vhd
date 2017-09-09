library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all
use ieee.std_logic_1164.all;
entity jisuan_xyz is 
  generic (udc : integer :=540;
           t  : std_logic_vector(15 downto 0) :="0000001111101000"--1000
			  );
			  
  port(
       clk  :in std_logic;
		 ua,ub:in std_logic_vector(15 downto 0);
		 n    :in std_logic_vector(3 downto 0);
		 tcm1,tcm2,tcm3 : out std_logic_vector(15 downto 0)
       );
		 end ;

architecture arch of jisuan_xyz is
signal c1 : std_logic_vector(15 downto 0):="0000110011010100";--3284,根号3×T/udc乘以1204后的结果
signal c2 : std_logic_vector(15 downto 0):="0000101100011100";--2844,1.5×T/udc乘以1204后的结果
signal x,y,z,fx,fy,fz : std_logic_vector(31 downto 0);
signal t1x,t2x : std_logic_vector(31 downto 0);
signal f1,f2,f3 : std_logic_vector (15 downto 0);
signal t1,t2 : std_logic_vector (15 downto 0);
signal ta,tb,tc,taz,tbz,tcz : std_logic_vector (15 downto 0);

begin
   process(clk)
	  begin
	     if clk'event and clk='1' then
		     x<=c1*ub;
			  y<=c1*ub+c2*ua;
			  z<=c1*ub-c2*ua;
		  end if;
   end process;
	
	process(clk)
	   begin
		  if clk'event and clk='1' then
		     fx<=(not x)+"00000000000000000000000000000001";
			  fy<=(not y)+"00000000000000000000000000000001";
			  fz<=(not z)+"00000000000000000000000000000001";
		  end if;
   end process;
	
	process(clk)
	   begin
		   if clk'event and clk='1' then
			   case n is 
				   when "0001" => t1x<=z;t2x<=y;
					when "0010" => t1x<=y;t2x<=fx;
					when "0011" => t1x<=fz;t2x<=x;
					when "0100" => t1x<=fx;t2x<=z;
					when "0101" => t1x<=x;t2x<=fy;
				   when "0110" => t1x<=fy;t2x<=fz;
				end case;
		   end if;
    end process;
	 
	-- process(clk)
	--    begin
	--	   if clk'event and clk='1' then
	--		   f1<=t*t1x/(t1x+t2x);
	--			f2<=t-t1x-t2x;
	--			f3<=t*t2x/(t1x+t2x);
	--	   end if;
	 --end process;
	 
	 process(clk)--求t1,t2
	   begin
		   if clk'event and clk='1' then
			   if f2<"00000000000000000000000000000000" then
               t1<=f1(15 downto 0);
					t2<=f1(15 downto 0);
			   else
				   t1<= t1x(15 downto 0);
					t2<= t2x(15 downto 0); 
				end if;
			end if;
	 end process;
	 
	 process(clk)--算taz
	   begin
		   if clk'event and clk='1' then
            taz<=t-t1-t2;
			end if;
	 end process;
	 
	 process(clk)--算ta
	   begin
		   if clk'event and clk='1' then
            ta<="00"&taz(15 downto 2);
			end if;
	 end process;
	
	 process(clk)--算tbz
	   begin
		   if clk'event and clk='1' then
			   tbz<='0'&t1(15 downto 1);
		   end if;
    end process;
	 
	 process(clk)--算tb
	   begin
		   if clk'event and clk='1' then
			   tb<=ta+tbz;
		   end if;
    end process;
	 
	 process(clk)--算tcz
	   begin
		   if clk'event and clk='1' then
			   tcz<='0'&t2(15 downto 1);
		   end if;
    end process;
	 
	 process(clk)--算tc
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
		   end case;
		  end if;
	 end process;
	 
	 end;
	 


	
	
	
	
		     