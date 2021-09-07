-------------------------------------------------------------------------------
--
-- Title       : prescaler
-- Design      : digital_lock
-- Author      : Pawe³ Król
-- Company     : AGH UST					 

library IEEE;
use IEEE.std_logic_1164.all;

entity prescaler is
	 port(
		 CLK : in STD_LOGIC;
		 O_CLK : out STD_LOGIC
	     );
end prescaler;
											 

architecture prescaler of prescaler is

constant divider : INTEGER := 100000;
signal count : INTEGER RANGE 0 TO divider := 0;

begin
	process(CLK)
	begin
		if rising_edge(CLK) then
			if count < divider then
				count <= count + 1;
			else
				count <= 0;
			end if;
		end if;
	end process;
	
	O_CLK <= '1' when count = divider else '0';
	
end prescaler;
