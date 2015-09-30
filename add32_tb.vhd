library ieee;
use ieee.std_logic_1164.all;

entity add32_tb is
end entity;

architecture arch of add32_tb is
	signal in0 : std_logic_vector(31 downto 0);
	signal in1 : std_logic_vector(31 downto 0);
	signal sum : std_logic_vector(31 downto 0);
	signal cin : std_logic := '0';
	signal cout : std_logic;
begin
	
	U_ADD32 : entity work.add32
		port map (
			in0 => in0,
			in1 => in1,
			sum => sum,
			cin => cin,
			cout => cout
		);
	
	process
	begin
		
		-- Add some random numbers
		in0 <= x"11111111";
		in1 <= x"12345678";
		wait for 10 ns;
		
		in0 <= x"F1111111";
		in1 <= x"F1111111";
		wait for 10 ns;
		
		in0 <= x"A2345678";
		in1 <= x"12345678";
		wait for 10 ns;
		
		in0 <= x"FFF45678";
		in1 <= x"F2345678";
		wait for 10 ns;
		
		in0 <= x"FFFFFFFF";
		in1 <= x"FFFFFFFF";
		wait for 10 ns;
		
		in0 <= x"00000000";
		in1 <= x"00000000";
		wait for 10 ns;
		
		in0 <= x"80000000";
		in1 <= x"80000000";
		wait for 10 ns;
		
		wait;
		
	end process;
	
end arch;