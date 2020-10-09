library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pfbDH is 
      generic( 	
                N_channels : integer := 4;
                N : integer := 17;    
	            ROMLEN : integer := 1024*N_channels*N/8 ); 
	port( 
		wclk    : in std_logic;
		rclk    : in std_logic;
        wdata   : in array(0 to N_channels*N/8 -1) of std_logic_vector(7 downto 0);
        rdata   : out std_logic_vector(7 downto 0); 
        --waddr   : in std_logic_vector(9 downto 0);
        --raddr   : in std_logic_vector(9 downto 0);
        emptied : out std_logic;
        filled  : out std_logic;
        reader_valid   : in std_logic;
        writer_valid  : in std_logic;
        --clear   : in std_logic;
        --done    : out std_logic
	);
end pfbDH;


architecture behv of pfbDH is 
    type ROM is array(0 to ROMLEN) of std_logic_vector(7 downto 0); 
    signal TABLE : ROM;--  = (others => (others => 0)); 
    signal wcounter : unsigned(9 downto 0);
    signal rcounter : unsigned(9 downto 0);
    signal rw  : std_logic; -- rw = reading from bram, ~rw = writing to bram
begin 


    writeto : process(wclk,rw) 
    begin 
        if (wclk'event and wclk='1') then 
            if (rw='0') then
                if (to_integer(wcounter) = ROMLEN-1 ) then
                    wcounter <= (others => '0');
                    rw <='1';
                elsif (writer_valid = '1')
                    wcounter <= wcounter + 1;
                    TABLE(to_integer(wcounter)) <= wdata;
                else 
                    -- waiting to read
                end if;
            end if;
        end if;
    end process;	

	
    readfrom: process(rclk,rw)
    begin
        if (rclk'event and rclk='1') then 
            if (rw = '1') then
                if (reader_valid='1') then 
                    rdata <= TABLE(to_integer(unsigned(rcounter)));
                    rcounter <= '1';
                elsif ( to_integer(rcounter) = ROMLEN-1)   
                    rw    <= '0';
                    TABLE <= (others => (others => '0'));  
                    rdata <= (others => '0'); 
                else 
                    -- waiting to read
                end if;        
            end if;
        end if;
    end process;
    
    
end behv;
