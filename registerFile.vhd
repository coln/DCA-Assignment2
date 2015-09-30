library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- MIPS Register file
-- rr0/1 is the inputs for reading a register
-- rw is the input for writing to a register
-- q0/1 are the read outputs
-- d is the write input
--
-- Data is written on the rising edge of "clk" only if "wr" is asserted
entity registerFile is
	generic (
		WIDTH : positive := 32
	);
	port (
		clk : in std_logic;
		rst : in std_logic;
		wr : in std_logic;
		
		rr0 : in std_logic_vector(integer(ceil(log2(real(WIDTH))))-1 downto 0);
		rr1 : in std_logic_vector(integer(ceil(log2(real(WIDTH))))-1 downto 0);
		q0 : out std_logic_vector(WIDTH-1 downto 0);
		q1 : out std_logic_vector(WIDTH-1 downto 0);
		
		rw : in std_logic_vector(integer(ceil(log2(real(WIDTH))))-1 downto 0);
		d : in std_logic_vector(WIDTH-1 downto 0)
	);
end entity;

architecture arch of registerFile is
	type register_array is array(WIDTH-1 downto 0) of std_logic_vector(WIDTH-1 downto 0);
	signal reg_array : register_array;
begin
	
	process(clk, rst)
		variable read_addr0 : integer;
		variable read_addr1 : integer;
		variable write_addr : integer;
	begin
		
		if(rst = '1') then
			for i in 0 to WIDTH-1 loop
				reg_array(i) <= (others => '0');
			end loop;
			
		elsif(rising_edge(clk)) then
			if(wr = '1') then
				write_addr := to_integer(unsigned(rw));
				reg_array(write_addr) <= d;
			end if;
			read_addr0 := to_integer(unsigned(rr0));
			read_addr1 := to_integer(unsigned(rr1));
			q0 <= reg_array(read_addr0);
			q1 <= reg_array(read_addr1);
		end if;
	end process;
	
end arch;