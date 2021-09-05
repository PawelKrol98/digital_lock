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
		 READ : in STD_LOGIC;
		 ENTER : in STD_LOGIC;
		 CLEAR : in STD_LOGIC;
		 O_READ : out STD_LOGIC;
		 O_ENTER : out STD_LOGIC;
		 O_CLEAR : out STD_LOGIC
	     );
end debouncer;



architecture debouncer of debouncer is

begin
	process(CLK)
	variable count : INTEGER RANGE 0 TO 100 := 0;
	begin
		if rising_edge(CLK) then 
			if count < 100 then
				count := count + 1;
			else
				count := 0;
				O_READ <= READ;
				O_ENTER <= ENTER;
				O_CLEAR <= CLEAR;
			end if;
		end if;
	end process;

end debouncer;
