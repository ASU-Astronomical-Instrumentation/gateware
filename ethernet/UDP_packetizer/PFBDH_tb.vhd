library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PFBDH_tb is 
      generic( N : integer := 82 );
end PFBDH_tb;


architecture test of PFBDH_tb is 
	signal read_counter : unsigned(9 downto 0);
	signal dumdata 		: unsigned(N-1 downto 0);

	signal wclk    : std_logic;
	signal rclk    : std_logic;
	signal wdata   : std_logic_vector(N-1 downto 0);
	signal rdata   : std_logic_vector(N-1 downto 0); 
	signal waddr   : std_logic_vector(9 downto 0);
	signal raddr   : std_logic_vector(9 downto 0);
	signal rready  : std_logic;
	signal bramrdy : std_logic;
	signal clr     : std_logic;
	signal done    : std_logic;
begin 
	dut : entity work.pfbDH(behv)
		port map( 
					wclk,       
					rclk,  
					wdata,  
					rdata,  
					waddr,  
					raddr,  
					rready, 
					bramrdy,
					clr,
					done      
				);
		WCLK_gen : process  --250 MHz
		begin
			wclk <= '0';
			wait for 2 ns;
			wclk <= '1';
			wait for 2 ns;
		end process;
	
		RCLK_gen : process  -- 100 MHz
		begin
			rclk <= '0';
			wait for 5 ns;
			rclk <= '1';
			wait for 5 ns;
		end process;
	
		process(wclk) -- dummy data load
		begin
			if (wclk'event and wclk='1') then
				dumdata <= dumdata +1;
				wdata <= std_logic_vector(dumdata);
			end if;
		end process;
		
		process(bramrdy)
		begin	
			if(bramrdy='1') then	
				rready <= '1';
				raddr <= read_counter;
				if (read_counter >= 1024-1) then
					rready <= '0';
					if (done = '1') then
						read_counter <= (others=> '0');
					end if;
				else
					read_counter <= read_counter + 1;
				end if;
			end if;
	    --wait;
	    end process;
end test;
