-------------------------------------------------------------------------------
--
-- Title       : debouncer
-- Design      : digital_lock
-- Author      : Pawe³ Król
-- Company     : AGH UST	 

library IEEE;
use IEEE.std_logic_1164.all;

entity debouncer is
	 port(
		 CLK : in STD_LOGIC;
		 PUSH : in STD_LOGIC;
		 O_PUSH : out STD_LOGIC
	     );
end debouncer;



architecture debouncer of debouncer is

begin
	process(CLK)
	constant divider : INTEGER := 10000000;
	variable count : INTEGER RANGE 0 TO divider := 0;
	begin
		if rising_edge(CLK) then 
			if count < divider then
				count := count + 1;
			else
				count := 0;
				O_PUSH <= PUSH;
			end if;
		end if;
	end process;

end debouncer;
