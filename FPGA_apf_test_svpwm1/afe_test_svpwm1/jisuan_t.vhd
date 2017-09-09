library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;

entity jisuan_t is 
  port(
         clk  :in std_logic;
         ua,ub: in signed(15 downto 0);
		 n    :in std_logic_vector(3 downto 0);
		 t1,t2,t_he: out signed(15 downto 0)
       );
  end ;
--直流电压540，t为1000
architecture arch of jisuan_t is
signal ua1,ub1: signed (15 downto 0);
signal c1 : signed(15 downto 0):="0000110111011011";--3547,根号3×T/udc乘以1024后的结果
signal c2 : signed(15 downto 0):="0000110000000000";--3072,1.5×T/udc乘以1024后的结果
signal c3 : signed(15 downto 0):="0000011011101101";--1773
signal x1,y1,z1,x2,y2,z2 : signed(31 downto 0);
signal x,y,z,fx,fy,fz : signed(15 downto 0);
signal t1buf,t2buf : signed (15 downto 0);
begin
	
   --process(clk)
   --  begin
	--   if clk'event and clk='1' then
	--      ua1<=conv_signed(ua,16);
	--      ub1<=conv_signed(ub,16);
	--   end if;
  -- end process;
   
   process(clk)
	  begin
	     if clk'event and clk='1' then
		      x1<=c1*ub;
			  y1<=c3*ub+c2*ua;
			  z1<=c3*ub-c2*ua;
		 end if;
   end process;
   
   process(clk)
	 begin
	   if clk'event and clk='1' then
	         x2<="0000000000"&x1(31 downto 10);
	         y2<="0000000000"&y1(31 downto 10);
	         z2<="0000000000"&z1(31 downto 10);
	   end if;
   end process;
   
   process(clk)
	 begin
	   if clk'event and clk='1' then
	          x<=x2(15 downto 0);
	          y<=y2(15 downto 0);
	          z<=z2(15 downto 0);
	   end if;
   end process;
	
	process(clk)
	   begin
		  if clk'event and clk='1' then
		      fx<=-x;
			  fy<=-y;
			  fz<=-z;
		  end if;
    end process;
	
	process(clk)
	   begin
		   if clk'event and clk='1' then
			   case n is 
				    when "0001" => t1buf<=z;t2buf<=y;
					when "0010" => t1buf<=y;t2buf<=fx;
					when "0011" => t1buf<=fz;t2buf<=x;
					when "0100" => t1buf<=fx;t2buf<=z;
					when "0101" => t1buf<=x;t2buf<=fy;
				    when "0110" => t1buf<=fy;t2buf<=fz;
					when others => null;
			   end case;
		   end if;
    end process;
    
    process(clk)
	begin
	   if clk'event and clk='1' then
	      t1<=t1buf;
	      t2<=t2buf;
	      t_he<=t1buf+t2buf;
	   end if;
    end process;
	end; 
				
				
				
				
				
				
				
				
				