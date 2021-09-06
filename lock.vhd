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
		 PUSH : in STD_LOGIC;
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
	process (PUSH)
	begin
		if rising_edge(PUSH) then
			if NUMBER <= 9 then
				if STATE = 0 then
					PASSWORD(0 to 3) <=  NUMBER;
					STATE <= STATE + 1;
				elsif STATE = 1 then 
					PASSWORD(4 to 7) <= NUMBER;
					STATE <= STATE + 1;
				elsif STATE = 2 then 
					PASSWORD(8 to 11) <= NUMBER;
					STATE <= STATE + 1;
				elsif STATE = 3 then 
					PASSWORD(12 to 15) <= NUMBER;
					STATE <= STATE + 1;
				end if;
			elsif NUMBER = 15 then
				if STATE = 1 then
					PASSWORD(0 to 3) <=  "0000";
					STATE <= STATE - 1;
				elsif STATE = 2 then 
					PASSWORD(4 to 7) <= "0000";
					STATE <= STATE - 1;
				elsif STATE = 3 then 
					PASSWORD(8 to 11) <= "0000";
					STATE <= STATE - 1;
				elsif STATE = 4 then 
					PASSWORD(12 to 15) <= "0000";
					STATE <= STATE - 1;
				end if;
			elsif NUMBER = 14 then
				if STATE = 4 then
					if CORRECT_PASSWORD = PASSWORD then
						STATE <= "101";
					else
						STATE <= "110";
					end if;
				elsif STATE = 5 or STATE = 6 then
					STATE <= "000";
					PASSWORD <= "0000000000000000";
				end if;
			end if;
		end if;
	end process;
	
	TYPED <= "1000" when STATE = "001" else
			 "1100" when STATE = "010" else
			 "1110" when STATE = "011" else
			 "1111" when STATE = "100" else
			 "0000";
	OPEN_DOOR <= '1' when STATE = "101" else
			  	 '0';
	CLOSE_DOOR <= '1' when STATE = "110" else
				  '0';
	
end lock;
