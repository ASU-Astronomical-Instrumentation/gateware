library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pfbDH is 
      generic( 	N : integer := 82;
	            ROMLEN : integer := 3*1024 ); 
	port( 
		wclk    : in std_logic;
		rclk    : in std_logic;
        wdata   : in std_logic_vector(N-1 downto 0);
        rdata   : out std_logic_vector(N-1 downto 0); 
        waddr   : in std_logic_vector(9 downto 0);
        raddr   : in std_logic_vector(9 downto 0);
        rready  : in std_logic;
        bramrdy : out std_logic;
        clr     : in std_logic;
        done    : out std_logic
	);
end pfbDH;


architecture behv of pfbDH is 
    type ROM is array(0 to ROMLEN) of std_logic_vector(N-1 downto 0); 
    signal TABLE : ROM;--  = (others => (others => 0)); 
    signal counter : unsigned(9 downto 0);
    signal rw  : std_logic; -- rw = reading from bram, ~rw = writing to bram
begin 


    writeto : process(wclk,rw) 
    begin 
        if (wclk'event and wclk='1') then 
            if (rw='0') then
                if (to_integer(counter) > ROMLEN-1 ) then
                    counter <= (others => '0');
                    rw <='1';
                else 
                    counter <= counter + 1;
                    TABLE(to_integer(counter)) <= wdata;
                end if;
            end if;
        end if;
    end process;	

	
    readfrom: process(rclk,rw)
        variable read : integer; 
    begin
        if (rclk'event and rclk='1') then
            done <= '0'; 
            if (rw= '1') then
                bramrdy <= '1';
                if (rready='1') then 
                    rdata <= TABLE(to_integer(unsigned(raddr)));
                    -- TODO: add idle
                else   
                    done <='1';
                    rw    <= '0';
                    TABLE <= (others => (others => '0'));  
                    rdata <= X"deadbeef"; 
                end if;
            else 
                bramrdy <='0';
                rdata <= (others => '0');                
            end if;
        end if;
    end process;
    
    
end behv;
