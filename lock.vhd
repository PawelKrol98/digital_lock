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
	signal NEW_PASSWORD: STD_LOGIC_VECTOR(0 to 15) := "0000000000000000";
	signal STATE: STD_LOGIC_VECTOR(0 to 4) := "00000";
	-- state 0 - ready to enter password
	-- state 1 - 1 digit entered
	-- state 2 - 2 digits entered
	-- state 3 - 3 digits entered
	-- state 4 - 4 digits entered and password not checked
	-- state 5 - password checked, door opened
	-- state 6 - password checked, door closed
	-- state 7 - changing password, entering actual password, 0 digit entered
	-- state 8 - changing password, entering actual password, 1 digits entered
	-- state 9 - changing password, entering actual password, 2 digits entered
	-- state 10 - changing password, entering actual password, 3 digits entered
	-- state 11 - changing password, entering actual password, 4 digits entered
	-- state 12 - changing password, entering new password, 0 digits entered
	-- state 13 - changing password, entering new password, 1 digits entered
	-- state 14 - changing password, entering new password, 2 digits entered
	-- state 15 - changing password, entering new password, 3 digits entered
	-- state 16 - changing password, entering new password,  digits entered
	signal CORRECT_PASSWORD: STD_LOGIC_VECTOR(0 to 15) := "0010000100110110";
begin
	process (PUSH)
	begin
		if rising_edge(PUSH) then
			if NUMBER <= 9 then
				if STATE = 0 or STATE = 7 then
					PASSWORD(0 to 3) <=  NUMBER;
					STATE <= STATE + 1;
				elsif STATE = 1 or STATE = 8 then 
					PASSWORD(4 to 7) <= NUMBER;
					STATE <= STATE + 1;
				elsif STATE = 2 or STATE = 9 then 
					PASSWORD(8 to 11) <= NUMBER;
					STATE <= STATE + 1;
				elsif STATE = 3 or STATE = 10 then 
					PASSWORD(12 to 15) <= NUMBER;
					STATE <= STATE + 1;
				elsif STATE = 12 then
					NEW_PASSWORD(0 to 3) <=  NUMBER;
					STATE <= STATE + 1;
				elsif STATE = 13 then 
					NEW_PASSWORD(4 to 7) <= NUMBER;
					STATE <= STATE + 1;
				elsif STATE = 14 then 
					NEW_PASSWORD(8 to 11) <= NUMBER;
					STATE <= STATE + 1;
				elsif STATE = 15 then 
					NEW_PASSWORD(12 to 15) <= NUMBER;
					STATE <= STATE + 1;
				end if;
			elsif NUMBER = 15 then
				if STATE = 1 or STATE = 8 then
					PASSWORD(0 to 3) <=  "0000";
					STATE <= STATE - 1;
				elsif STATE = 2 or STATE = 9 then 
					PASSWORD(4 to 7) <= "0000";
					STATE <= STATE - 1;
				elsif STATE = 3 or STATE = 10 then 
					PASSWORD(8 to 11) <= "0000";
					STATE <= STATE - 1;
				elsif STATE = 4 or STATE = 11 then 
					PASSWORD(12 to 15) <= "0000";
					STATE <= STATE - 1;
				elsif STATE = 13 then
					NEW_PASSWORD(0 to 3) <=  "0000";
					STATE <= STATE - 1;
				elsif STATE = 14 then 
					NEW_PASSWORD(4 to 7) <= "0000";
					STATE <= STATE - 1;
				elsif STATE = 15 then 
					NEW_PASSWORD(8 to 11) <= "0000";
					STATE <= STATE - 1;
				elsif STATE = 16 then 
					NEW_PASSWORD(12 to 15) <= "0000";
					STATE <= STATE - 1;
				end if;
			elsif NUMBER = 14 then
				if STATE = 4 or STATE = 11then
					if CORRECT_PASSWORD = PASSWORD then
						if STATE = 11 then 
							STATE <= STATE + 1;
						else
							STATE <= "00101";
						end if;
					else
						STATE <= "00110";
					end if;
				elsif STATE = 5 or STATE = 6 then
					STATE <= "00000";
					PASSWORD <= "0000000000000000";
				elsif STATE = 16 then
					STATE <= "00000";
					CORRECT_PASSWORD <= NEW_PASSWORD;
				end if;
			elsif NUMBER = 10 then
				if STATE = 0 then
					STATE <= "00111";
				end if;
			end if;
		end if;
	end process;
	
	TYPED <= "1000" when STATE = 1 or STATE = 8 or STATE = 13 else
			 "1100" when STATE = 2 or STATE = 9 or STATE = 14 else
			 "1110" when STATE = 3 or STATE = 10 or STATE = 15 else
			 "1111" when STATE = 4 or STATE = 11 or STATE = 16 else
			 "0000";
	OPEN_DOOR <= '1' when STATE = "00101" or STATE >= 7 else
			  	 '0';
	CLOSE_DOOR <= '1' when STATE >= 6 else
				  '0';
	
end lock;
