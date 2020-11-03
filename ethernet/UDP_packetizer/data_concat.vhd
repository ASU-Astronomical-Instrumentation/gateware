library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_to_bytes is 
        generic( 	N_channels : integer := 4;
                    N : integer := 17;          
        ); 
	port( 
		clk    : in std_logic;
        x   : in array(0 to N_channels-1) of std_logic_vector(N-1 downto 0);
        y   : out array(0 to N_channels*N/8 -1) of std_logic_vector(7 downto 0)
	);
end data_to_bytes;


architecture behv of data_to_bytes is 
    signal counter : unsigned(9 downto 0);
    signal large_x_vec : std_logic_vector(N*N_channels-1 downto 0)
begin 


    combine : process(clk) 
    begin 
        if (clk'event and clk='1') then 
            large_x_vec <= x(0) & x(1) & x(2) & x(3);
            for i in (0 to N_channels*N/8 -1) loop
                y(i) <= large_x_vec(i*8+7 downto i*8);
            end loop;
        end if;
    end process;	
       
end behv;
