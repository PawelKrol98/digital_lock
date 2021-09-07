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
signal DELAY : std_logic_vector(2 downto 0);

begin
	process(CLK)									 
	begin
		if rising_edge(CLK) then
			DELAY <= DELAY(1 downto 0) & PUSH;	-- shift register  
		end if;
	end process;
	O_PUSH <= '1' when DELAY = "011" else '0';
end debouncer;
