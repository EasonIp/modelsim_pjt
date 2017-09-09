library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;

entity sv is 
  port(
         clk               : in  std_logic;
		 ua,ub             : in  signed(15 downto 0);
		 en                : in  std_logic;
		 tcm1,tcm2,tcm3    : out signed(15 downto 0)

       );
end ;
architecture arch of sv is 
type typestate is(idle,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14);
signal state : typestate :=idle;
signal ua1,uagenhao3,ub1: signed(15 downto 0);
signal a: signed (15 downto 0) :="0000011011101110";--1774=1.732*1024
signal b1,b2: signed (31 downto 0); 
signal const1 : signed(15 downto 0):="0000110111011011";--3547,根号3×T/udc乘以1024后的结果
signal const2 : signed(15 downto 0):="0000110000000000";--3072,1.5×T/udc乘以1024后的结果
signal const3 : signed(15 downto 0):="0000011011101101";--1773,二分之一根号三*T/Udc*1024
signal c1,c2,c3 : signed (15 downto 0);
signal x1,y1,z1,x2,y2,z2 : signed(31 downto 0);
signal x,y,z,fx,fy,fz : signed(15 downto 0);
signal t1,t2: signed (15 downto 0);	
signal s: std_logic_vector(3 downto 0);
signal ta,tb,tc,taz,tbz,tcz : signed (15 downto 0);
signal t: signed(15 downto 0) :="0000011111010000";--2000
signal en1,en2 : std_logic;

begin
  process(clk)
  begin
    if clk'event and clk='1' then
       en1<=en;
       en2<=en1;
    end if;
  end process;

  process(clk)
    begin 
      if clk'event and clk='1' then
         case state is
            when idle =>
              if en2='0' and en1='1' then
                ua1<=ua;
                ub1<=ub;
                state<=s1;
              else
                state<=idle;
              end if;
            when s1 =>
                b1<=ua1*a;
                
                x1<=const1*ub1;
			    y1<=const3*ub1+const2*ua1;
			    z1<=const3*ub1-const2*ua1;
                state<=s2;
            when s2 =>
                b2<="0000000000"&b1(31 downto 10);
                
	            x2<="0000000000"&x1(31 downto 10);
	            y2<="0000000000"&y1(31 downto 10);
	            z2<="0000000000"&z1(31 downto 10);
                state<=s3;
            when s3 =>
                uagenhao3<=b2(15 downto 0);
                
	            x<=x2(15 downto 0);
	            y<=y2(15 downto 0);
	            z<=z2(15 downto 0);
                state<=s4;
            when s4 =>
                c1<=ub;
                c2<=uagenhao3-ub;
                c3<=uagenhao3+ub;
                
		        fx<=-x;
			    fy<=-y;
			    fz<=-z;
                state<=s5;
            when s5 =>
                s<="0000";
                state<=s6;
            when s6 =>
	           if c1>0 or c1=0 then
                  s<=s+"0001";
	           end if;
	              state<=s7;
	        when s7 =>
	           if c2>0 or c2=0 then
                  s<=s+"0010";
	           end if;
	              state<=s8;
	        when s8 =>
	           if c3<0 or c3=0 then
                  s<=s+"0100";
	           end if;
	              state<=s9;
	        when s9 =>
	              if s="0001" then t1<=z;t2<=y;
               elsif s="0010" then t1<=y;t2<=fx;
               elsif s="0011" then t1<=fz;t2<=x;
               elsif s="0100" then t1<=fx;t2<=z;
               elsif s="0101" then t1<=x;t2<=fy;
               elsif s="0110" then t1<=fy;t2<=fz;
               end if;
               state<=s10;
            when s10 =>
               taz<=t-t1-t2;
               tbz<='0'&t1(15 downto 1);
               tcz<='0'&t2(15 downto 1);
               state<=s11;
            when s11 =>
               ta<="00"&taz(15 downto 2);
               state<=s12;
            when s12 =>
               tb<=ta+tbz; 
               state<=s13;
            when s13 =>
               tc<=tb+tcz;
               state<=s14;
            when s14 =>
	              if s="0001" then tcm1<=tb;tcm2<=ta;tcm3<=tc;
               elsif s="0010" then tcm1<=ta;tcm2<=tc;tcm3<=tb;
               elsif s="0011" then tcm1<=ta;tcm2<=tb;tcm3<=tc;
               elsif s="0100" then tcm1<=tc;tcm2<=tb;tcm3<=ta;
               elsif s="0101" then tcm1<=tc;tcm2<=ta;tcm3<=tb;
               elsif s="0110" then tcm1<=tb;tcm2<=tc;tcm3<=ta;
               end if;
               state<=idle;
            when others=>state<=idle;
         end case;
      end if;
    end process;
end;
                  
               
               
               
            
  
    
	         
                
                
                
                
                
                
                
                
                
                
                
                
                
			    
            
                
            
            
  

  

  
		  
		 
	    