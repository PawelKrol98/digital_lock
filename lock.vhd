-------------------------------------------------------------------------------
--
-- Title       : lock
-- Design      : digital_lock
-- Author      : Pawe³ Król
-- Company     : AGH UST					  

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity lock is
	 port(
		 READ : in STD_LOGIC;
		 CLEAR : in STD_LOGIC;
		 ENTER : in STD_LOGIC;
		 NUMBER : in STD_LOGIC_VECTOR(0 to 3);
		 OPEN_DOOR : out STD_LOGIC := '0';
		 CLOSE_DOOR : out STD_LOGIC := '0';
		 TYPED : out STD_LOGIC_VECTOR(0 to 3) := "0000"
	     );
end lock;
												  

architecture lock of lock is
	signal PASSWORD: STD_LOGIC_VECTOR(0 to 15) := "0000000000000000";		 
	signal STATE: STD_LOGIC_VECTOR(0 to 2) := "000";
	-- state 0 - ready to enter password
	-- state 1 - 1 digits entered
	-- state 2 - 2 digits entered
	-- state 3 - 3 digits entered
	-- state 4 - 4 digits entered and password not checked
	-- state 5 - password checked, door opened
	-- state 6 - password checked, door closed
	constant CORRECT_PASSWORD: STD_LOGIC_VECTOR(0 to 15) := "0010000100110110";
begin
	process (READ, CLEAR, ENTER)
	begin
		if falling_edge(READ) or falling_edge(CLEAR) then
			if READ = '1' then
				if STATE = "000" then
					STATE <= STATE + 1;
					PASSWORD(0 to 3) <= NUMBER;
				elsif STATE = "001" then
					STATE <= STATE + 1;	 
					PASSWORD(4 to 7) <= NUMBER;
				elsif STATE = "010" then
					STATE <= STATE + 1;	
					PASSWORD(8 to 11) <= NUMBER;
				elsif STATE = "011" then
					STATE <= STATE + 1;
					PASSWORD(12 to 15) <= NUMBER;
				end if;	
			elsif CLEAR='1' then
				if STATE = "001" then
					STATE <= STATE - 1;
					PASSWORD(0 to 3) <= "0000";
				elsif STATE = "010" then
					STATE <= STATE - 1;	 
					PASSWORD(4 to 7) <= "0000";
				elsif STATE = "011" then
					STATE <= STATE - 1;	
					PASSWORD(8 to 11) <= "0000";
				elsif STATE = "100" then
					STATE <= STATE - 1;
					PASSWORD(12 to 15) <= "0000";
				end if;
			end if;
		end if;
		if ENTER'event and ENTER = '0' then
			if STATE = "100" then
				if PASSWORD = CORRECT_PASSWORD then
					STATE <= "101";
					OPEN_DOOR <= '1';
				else
					STATE <= "110";
					CLOSE_DOOR <= '1';
				end if;
			elsif STATE = "101" or STATE = "110" then
				STATE <= "000";
				OPEN_DOOR <= '0';
				CLOSE_DOOR <= '0';
				PASSWORD <= "0000000000000000";
			end if;
		end if;
	end process;
	
	
	TYPED <= "1000" when STATE = "001" else
			 "1100" when STATE = "010" else
			 "1110" when STATE = "011" else
			 "1111" when STATE = "100" else
			 "0000";
	
end lock;
