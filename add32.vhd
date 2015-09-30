library ieee;
use ieee.std_logic_1164.all;

entity add32 is
	port (
		in0 : in std_logic_vector(31 downto 0);
		in1 : in std_logic_vector(31 downto 0);
		sum : out std_logic_vector(31 downto 0);
		cin : in std_logic;
		cout : out std_logic
	);
end entity;

architecture arch of add32 is
	signal carry : std_logic_vector(8 downto 0);
begin
	
	-- Ripple carry using 8 4-bit carry look-ahead adders
	carry(0) <= cin;
	
	U_ADD : for i in 1 to 8 generate
		
		U_CLA4 : entity work.cla4
			port map (
				in0 => in0((i * 4) - 1 downto (i - 1) * 4),
				in1 => in1((i * 4) - 1 downto (i - 1) * 4),
				sum => sum((i * 4) - 1 downto (i - 1) * 4),
				cin => carry(i - 1),
				cout => carry(i)
			);
		
	end generate;
	
	cout <= carry(8);
	
end arch;