library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity deadtime is
generic (n : integer:=80);
port( clk : in std_logic;
      pwmin: in std_logic;
      pwmout : out std_logic
      );
end;

architecture deadtime of deadtime is
signal cnt :integer range 0 to n;

begin
  process(clk)
  begin
     if (clk'event and clk='1') then
        if pwmin='1' then
           if cnt=n then
               cnt<=n;
               pwmout<='1';
           else 
               pwmout<='0';
               cnt<=cnt+1;
           end if;
        else
           cnt<=0;
           pwmout<='0';
        end if;
     end if;

  end process;
end ;