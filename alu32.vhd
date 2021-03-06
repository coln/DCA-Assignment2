library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- MIPS 32-bit ALU
entity alu32 is
	port (
		-- Inputs A & B
		inA : in std_logic_vector(31 downto 0);
		inB : in std_logic_vector(31 downto 0);
		
		-- Controls, Shift amount (shamt), and shift direction (shdir)
		control : in std_logic_vector(3 downto 0);
		shiftAmt : in std_logic_vector(4 downto 0);
		shiftDir : in std_logic;
		
		-- ALU Output
		output : out std_logic_vector(31 downto 0);
		carry : out std_logic;
		zero : out std_logic;
		sign : out std_logic;
		overflow : out std_logic
	);
end entity;

architecture arch of alu32 is
	signal A : std_logic_vector(31 downto 0);
	signal B : std_logic_vector(31 downto 0);
	
	signal logical_and : std_logic_vector(31 downto 0);
	signal logical_or : std_logic_vector(31 downto 0);
	signal add : std_logic_vector(32 downto 0);
	signal set_on_less_than : std_logic_vector(31 downto 0);
	signal shift_output : std_logic_vector(31 downto 0);
	
	signal mux_output : std_logic_vector(31 downto 0);
	
	function bool_to_logic(expr : boolean) return std_logic is
	begin
		if(expr) then
			return '1';
		else
			return '0';
		end if;
	end bool_to_logic;
	
begin
	
	-- Final output of the ALU
	U_MUX4 : entity work.mux4
		generic map (
			WIDTH => 32
		)
		port map (
			sel => control(1 downto 0),
			in0 => logical_and,
			in1 => logical_or,
			in2 => add(31 downto 0),
			in3 => set_on_less_than,
			output => mux_output
		);
	
	with control select
		output <= shift_output when "0011",
				  mux_output when others;
	
	
	-- Control signals:
	-- bit3 = A inverse
	-- bit2 = B inverse
	-- bit1/0 = MUX4 select
	with control(3) select
		A <= inA when '0',
			 not inA when others;
	
	with control(2) select
		B <= inB when '0',
			 not inB when others;
	
	-- Since the control line is setting A/B inverse
	-- addition and subtraction remains the same
	add <= std_logic_vector(resize(unsigned(A), 33) + resize(unsigned(B), 33));
	-- Sign flags
	process(A, B, control, add)
	begin
		carry <= add(32);
		sign <= add(31);
		zero <= '0';
		overflow <= '0';
		
		-- Essentially a giant OR of all the bits to check for zero
		if(signed(add(31 downto 0)) = 0) then
			zero <= '1';
		end if;
		
		-- If both input and output signs conflict, overflow
		if((A(31) = '1' and B(31) = '1' and add(31) = '0')
			or (A(31) = '0' and B(31) = '0' and add(31) = '1'))
		then
			overflow <= '1';
		end if;
	end process;
	
	
	-- Logical NOR is set using the A/B inverse control lines
	logical_and <= A and B;
	logical_or <= A or B;
	
	-- SLT unsigned -> control = "0111"
	-- SLT signed   -> control = "1111"
	-- Determine which type based on control(3)
	set_on_less_than(31 downto 1) <= (others => '0');
	with control(3) select
		set_on_less_than(0) <= bool_to_logic(unsigned(inA) < unsigned(inB)) when '0',
							   bool_to_logic(signed(inA) < signed(inB)) when others;
	
	
	-- Shift left or right by shiftAmnt
	with shiftDir select
		shift_output <= std_logic_vector(SHIFT_LEFT(unsigned(B), to_integer(unsigned(shiftAmt)))) when '0',
						std_logic_vector(SHIFT_RIGHT(unsigned(B), to_integer(unsigned(shiftAmt)))) when others;
	
end arch;