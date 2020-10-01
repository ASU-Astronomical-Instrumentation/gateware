library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avg_tb is 
      generic( N : integer := 16 );
end avg_tb;


architecture test of avg_tb is 
	signal clk : std_logic;
    signal   x : std_logic_vector(N-1 downto 0);
    signal   y : std_logic_vector(N-1 downto 0);

	signal     sstop : std_logic;
	signal   dumdata : unsigned(N-1 downto 0);
	signal   periods : unsigned(8 downto 0);
	signal  inp_data : std_logic_vector(N-1 downto 0);

begin 
	dut : entity work.growing_avg(behv)
		port map( 
                    clk,
                    x,
                    y
				);

		CLK_gen : process  --250 MHz
		begin
			clk <= '0';
			wait for 5 ns;
			clk <= '1';
			wait for 5 ns;
		end process;
	
		process(clk) --dummy data load
		begin	
			if (clk'event and clk='1') then
				dumdata  <= dumdata +1;
				x <= std_logic_vector(dumdata);
			end if;
		end process;

		process
		begin
			wait for 100 ns;
			wait;
		end process;		
end test;