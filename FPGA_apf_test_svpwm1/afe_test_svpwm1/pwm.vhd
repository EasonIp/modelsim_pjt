library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;--有符号数
use ieee.std_logic_1164.all;

entity pwm is 
  port(
         clk      :in std_logic;
		 clk_cnt  :in std_logic;
		 tongbu:in std_logic;
		 tcm1i,tcm2i,tcm3i : in std_logic_vector(15 downto 0);
		 u1,v1,w1 : out std_logic

       );
		 end ;

architecture arch of pwm is
signal up_down : std_logic:='1';
type statecounter is (idle,up,down);
signal state : statecounter := idle;
signal cnt : integer range 0 to 2000:=0;
signal cnt_ct: integer range 0 to 1;
signal tcm1,tcm2,tcm3 : std_logic_vector (15 downto 0);
signal a : integer range 0 to 2000:=0;
signal cout : std_logic_vector (15 downto 0);
signal tb1,tb2,santb,t1,t2:std_logic;
begin
	
process(clk)
begin
  if clk'event and clk='1' then
     tb1<=tongbu;
     tb2<=tb1;

     if  (tb2='0' and tb1='1') then
      if cnt_ct=1 then
        cnt_ct<=0;
      else
        cnt_ct<=cnt_ct+1;
      end if;
     end if;
     
     if cnt_ct=1 then
        santb<='1';
     else
        santb<='0';
     end if;
         
  end if;
end process;

 process(clk_cnt)       --该进程产生三角波
        begin
        if clk_cnt'event and clk_cnt='1' then
        t1<=santb;
        t2<=t1;
             case state is
                when idle=>
                         if up_down='1' then
                             state<=up;
                         else 
                             state<=down;
                         end if;
                when up =>
                     if(t2='0' and t1='1') then
                        cnt<=0;
                        state<=idle;
                        up_down<='1';
                     else
                         if cnt=1999 then
							 up_down<='0';
                             state<=down;
                             cnt<=cnt+1;
                         else
                             state<=up;
                             cnt<=cnt+1;
                         end if;
                     end if;    
                when down =>
                     if(t2='0' and t1='1') then
                        cnt<=0;
                        state<=idle;
                        up_down<='1';
                     else   
                         if cnt=1 then
						      up_down<='1';
                              state<=up;
                              cnt<=cnt-1;
                         else
                              state<=down;
                              cnt<=cnt-1;
                         end if;
                     end if;    
                when others=>state<=idle;
             end case;            
        end if;
   end process;
	
	process(clk)
	  begin
	     if clk'event and clk='1' then
		    if cnt=0 or cnt=2000 then
			      tcm1<=tcm1i;
				  tcm2<=tcm2i;
				  tcm3<=tcm3i; 
			end if;
		 end if;
   end process;
	
   process(clk,a)        
    begin
      if clk'event and clk='1' then
         a<=cnt;
      end if;
   end process;
   
	process(clk,a)
	  begin
	     if clk'event and clk='1' then
		     cout<=conv_std_logic_vector(a,16);
		  end if;
   end process;
	
	process(clk_cnt)
	  begin
	     if clk'event and clk='1' then
		     if cout>tcm1 then
			    u1<='0';
			  else
			    u1<='1';
			  end if;
			  if cout>tcm2 then
			    v1<='0';
			  else
			    v1<='1';
			  end if;
			  if cout>tcm3 then
			    w1<='0';
			  else
			    w1<='1';
			  end if;
		  end if;
   end process;
	

	end;
		  
		  
		  
		  
		  