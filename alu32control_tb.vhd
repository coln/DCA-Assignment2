library ieee;
use ieee.std_logic_1164.all;

entity alu32control_tb is
end entity;

architecture arch of alu32control_tb is
	signal func : std_logic_vector(5 downto 0);
	signal ALUop : std_logic_vector(2 downto 0);
	signal control : std_logic_vector(3 downto 0);
	signal shiftDir : std_logic;
begin
	
	U_ALU32CONTROL : entity work.alu32control
		port map (
			func => func,
			ALUop => ALUop,
			control => control,
			shiftDir => shiftDir
		);
	
	process
	begin
		
		-- Set some function values to determine the controls
		-- Controller should ignore func unless ALUop = "100"
		
		-- AND
		ALUop <= "000";
		func <= "100000";
		wait for 10 ns;
		
		-- Add
		ALUop <= "010";
		wait for 10 ns;
		
		-- SLT signed
		ALUop <= "111";
		wait for 10 ns;
		
		-- Function add
		ALUop <= "100";
		func <= "100000";
		wait for 10 ns;
		
		-- Function sub
		func <= "100010";
		wait for 10 ns;
		
		-- Function shift right
		func <= "000010";
		wait for 10 ns;
		
		-- Function shift left
		func <= "000000";
		wait for 10 ns;
		
		wait;
		
	end process;
	
end arch;