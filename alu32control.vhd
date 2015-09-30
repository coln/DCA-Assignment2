library ieee;
use ieee.std_logic_1164.all;

-- MIPS ALU Control unit
entity alu32control is
	port (
		func : in std_logic_vector(5 downto 0);
		ALUop : in std_logic_vector(2 downto 0);
		control : out std_logic_vector(3 downto 0);
		shiftDir : out std_logic
	);
end entity;

architecture arch of alu32control is
	constant OP_ADD : std_logic_vector(3 downto 0) := "0010";
	constant OP_SUB : std_logic_vector(3 downto 0) := "0110";
	constant OP_AND : std_logic_vector(3 downto 0) := "0000";
	constant OP_OR : std_logic_vector(3 downto 0) := "0001";
	constant OP_NOR : std_logic_vector(3 downto 0) := "1100";
	constant OP_SLT_SIGNED : std_logic_vector(3 downto 0) := "0111";
	constant OP_SLT_UNSIGNED : std_logic_vector(3 downto 0) := "1111";
	constant OP_SHIFT : std_logic_vector(3 downto 0) := "0011";
	
	signal func_cntrl : std_logic_vector(3 downto 0);
begin
	
	-- Determine shift direction based upon function code
	with func select
		shiftDir <= '1' when "000010",
					'0' when others;
	
	-- Determine the control bits (used below) for each function code
	with func select
		func_cntrl <= OP_ADD when "100000",
					  OP_ADD when "100001",
					  OP_AND when "100100",
					  OP_ADD when "001000",
					  OP_NOR when "100111",
					  OP_OR when "100101",
					  OP_SLT_SIGNED when "101010",
					  OP_SLT_UNSIGNED when "101011",
					  OP_SHIFT when "000000",
					  OP_SHIFT when "000010",
					  OP_SUB when "100010",
					  OP_SUB when "100011",
					  "0000" when others;
	
	-- Determine the output controls using "ALUop" and "func"
	with ALUop select
		control <= func_cntrl when "100",
				   OP_AND when "000",
				   OP_SUB when "001",
				   OP_ADD when "010",
				   OP_OR when "110",
				   OP_SLT_UNSIGNED when "101",
				   OP_SLT_SIGNED when "111",
				   "0000" when others;
	
end arch;
