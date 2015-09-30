library ieee;
use ieee.std_logic_1164.all;

entity alu32_tb is
end entity;

architecture arch of alu32_tb is
	signal inA : std_logic_vector(31 downto 0);
	signal inB : std_logic_vector(31 downto 0);
	signal control : std_logic_vector(3 downto 0);
	signal shiftAmt : std_logic_vector(4 downto 0);
	signal shiftDir : std_logic;
	signal output : std_logic_vector(31 downto 0);
	signal carry : std_logic;
	signal zero : std_logic;
	signal sign : std_logic;
	signal overflow : std_logic;
begin
	
	U_ALU32 : entity work.alu32
		port map (
			inA => inA,
			inB => inB,
			control => control,
			shiftAmt => shiftAmt,
			shiftDir => shiftDir,
			output => output,
			carry => carry,
			zero => zero,
			sign => sign,
			overflow => overflow
		);
	
	process
	begin
		
		inA <= x"FFFF1234";
		inB <= x"12345678";
		
		-- Addition
		control <= "0010";
		wait for 10 ns;
		
		-- Subtraction
		control <= "0110";
		wait for 10 ns;
		
		-- AND
		control <= "0000";
		wait for 10 ns;
		
		-- OR
		control <= "0001";
		wait for 10 ns;
		
		-- NOR
		control <= "1100";
		wait for 10 ns;
		
		-- SLT signed
		control <= "0111";
		wait for 10 ns;
		
		-- SLT unsigned
		control <= "1111";
		wait for 10 ns;
		
		-- Shift Left
		shiftAmt <= "01000";
		shiftDir <= '0';
		control <= "0011";
		wait for 10 ns;
		
		-- Shift Right
		shiftAmt <= "01000";
		shiftDir <= '1';
		control <= "0011";
		wait for 10 ns;
		
		wait;
		
	end process;
	
end arch;