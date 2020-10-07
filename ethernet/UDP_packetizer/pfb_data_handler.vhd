library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pfbDH is 
      generic( 	   N : integer := 82;
		AVGS : integer := 18;
	      ROMLEN : integer := 1024 ); 
	port(
		wclk : in std_logic;
		rclk : in std_logic;
	       wdata : in std_logic_vector(N-1 downto 0);
	       rdata : out std_logic_vector(N-1 downto 0); 
	       waddr : in std_logic_vector(9 downto 0);
	       raddr : in std_logic_vector(9 downto 0);
              rready : in std_logic;
		 clr : in std_logic
	);
end pfbDH;


architecture behv of pfbDH is 
    type ROM is array(0 to ROMLEN) of std_logic_vector(N-1 downto 0); 
    signal TABLE : ROM;

    signal average_number : unsigned(4 downto 0);
    signal wcounter : unsigned(9 downto 0); 
    signal write_en : std_logic;
    signal read_en  : std_logic;
begin 
    process(wclk) 
    begin 
        if rising_edge(wclk) then 
            if (average_number > AVGS) then
                read_en <= '1';
                write_en <= '0';
            else 
                write_en<='1';
                read_en<='0'; 
                if (average_number = 0) then
                    average_number <= 1;
                    TABLE(waddr) <= wdata;
                else
                    average_number <= average_number + 1; 
                    TABLE(waddr) <= (('0' & TABLE(waddr) + '0' & wdata) srl 1);
		end if;
            end if;
    end process;	
	
    process(rclk,read_en,write_en)
        variable read : integer; 
    begin
        if rising_edge(rclk) then 
            if (read_en = '1') and (rready='1') then 
                rdata <= TABLE(raddr);
            elsif (write_en='0') 
                read_en<='0';
                write_en<='1';
            else 
                rdata <= X"68206e6f21" -- "h no!"
            end if;
        end if;
    end process;	
	
end behv;


-- This is a datastorage module for the PFB data, looding in the concatednated data, 
-- data will be loaded and average a set number of times, once the data is averaged it will be 
-- free to readout (this is done where 'average time' <~ 'udp down time'), UDP in the data byte file 
-- has a user data input signal we can use to trigger the reading. This needs to be modified to save the 
-- last position read from memory since we have more bytes in a 1024-PFB then our current UDP datapacket 
-- (UDP: 9216 Bytes, UDP: 1040 Bytes; I think we can increase the UDP size though. So We should probably work on that) 


