-------------------------------------------------------------------------------
--
-- Title       : decoder
-- Design      : digital_lock
-- Author      : Pawe³ Król
-- Company     : AGH UST	  

library IEEE;
use IEEE.std_logic_1164.all;

entity decoder is
	 port(
		 R : in STD_LOGIC_VECTOR(0 to 3);
		 C : buffer STD_LOGIC_VECTOR(0 to 3) := "0000";
		 CLK : in STD_LOGIC;
		 PUSH : out STD_LOGIC := '0';
		 NUMBER : out STD_LOGIC_VECTOR(0 to 3)
	     );
end decoder;


architecture decoder of decoder is			 
begin
	process(CLK)
	variable count : INTEGER RANGE 0 TO 100 := 0;
	begin
		if rising_edge(CLK) then
			if(count < 100) then
				count := count +1;
			else
				count := 0;
				if C = "0000" then
					if R = "1111" then
						PUSH <= '0';
					end if;
					C <= "0111";
				elsif C = "0111" then
					if R = "0111" then
					elsif R = "1011" then
					elsif R = "1101" then
					elsif R = "1110" then
					end if;
					C <= "1011";
				elsif C	= "1011" then
					if R = "0111" then
						NUMBER <= "1110";
						PUSH <= '1';
					elsif R = "1011" then
						NUMBER <= "1001";
						PUSH <= '1';
					elsif R = "1101" then
						NUMBER <= "0110";
						PUSH <= '1';
					elsif R = "1110" then
						NUMBER <= "0011";
						PUSH<= '1';
					end if;
					C <= "1101";
				elsif C	= "1101" then
					if R = "0111" then
						NUMBER <= "1111";
						PUSH <= '1';
					elsif R = "1011" then
						NUMBER <= "1000";
						PUSH <= '1';
					elsif R = "1101" then
						NUMBER <= "0101";
						PUSH <= '1';
					elsif R = "1110" then
						NUMBER <= "0010";
						PUSH <= '1';
					end if;
					C <= "1110";
				elsif C = "1110" then
					if R = "0111" then
						NUMBER <= "0000";
						PUSH <= '1';
					elsif R = "1011" then
						NUMBER <= "0111";
						PUSH <= '1';
					elsif R = "1101" then
						NUMBER <= "0100";
						PUSH <= '1';
					elsif R = "1110" then
						NUMBER <= "0001";
						PUSH <= '1';
					end if;
					C <= "0000";
				end if;
			end if;
		end if;
	end process;
end decoder;
