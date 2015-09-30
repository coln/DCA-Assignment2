library ieee;
use ieee.std_logic_1164.all;

entity registerFile_tb is
end entity;

architecture arch of registerFile_tb is
	signal done : std_logic := '0';
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';
	signal wr : std_logic := '0';
	signal rr0 : std_logic_vector(4 downto 0);
	signal rr1 : std_logic_vector(4 downto 0);
	signal q0 : std_logic_vector(31 downto 0);
	signal q1 : std_logic_vector(31 downto 0);
	signal rw : std_logic_vector(4 downto 0);
	signal d : std_logic_vector(31 downto 0);
begin
	
	U_REGFILE : entity work.registerFile
		port map (
			clk => clk,
			rst => rst,
			wr => wr,
			rr0 => rr0,
			rr1 => rr1,
			q0 => q0,
			q1 => q1,
			rw => rw,
			d => d
		);
	
	clk <= not clk and not done after 5 ns;
	
	process
	begin
		rst <= '1';
		wait for 10 ns;
		
		-- Write some data and read a random register
		rst <= '0';
		wr <= '1';
		rr0 <= "00101";
		rr1 <= "10001";
		rw <= "00001";
		d <= x"DEADBEE7";
		wait for 10 ns;
		
		-- Read the data back and make sure it doesn't write again
		wr <= '0';
		rr0 <= "00001";
		rr1 <= "00010";
		rw <= "01010";
		wait for 10 ns;
		
		rr0 <= "01010";
		rr1 <= "01010";
		wait for 10 ns;
		
		-- Write to one and read from same one
		wr <= '1';
		rr0 <= "10000";
		rr1 <= "10000";
		rw <= "10000";
		d <= x"BEADFEED";
		wait for 20 ns;
		
		done <= '1';
		wait;
		
	end process;
	
end arch;