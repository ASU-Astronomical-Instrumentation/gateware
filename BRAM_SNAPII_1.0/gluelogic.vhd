library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity splitter is 
    generic( data_width : integer := 32*4 );
    port(
		clkA : in std_logic; -- 512 MHz
		clkB : in std_logic; -- 256 MHz
		Q : out std_logic_vector(2*data_width-1 downto 0);
		D : in std_logic_vector(data_width-1 downto 0)
	);
end splitter;

architecture behv of splitter is 
 SIGNAL D0 : std_logic_vector(data_width-1 downto 0);
 SIGNAL D1 : std_logic_vector(2*data_width-1 downto 0); 
begin 
    process (clkA,D) 
    begin
        if (clkA'event and clkA='1') then
            D0 <= D;
        end if;
    end process;
    
    process (clkB,D,D0)   
    begin
        if (clkB'event and clkB='1') then
            D1 <= D & D0; -- 0XFFFF & 0x0000 == 0xFFFF0000
        end if;
    end process;
    
    process (clkB,D1)
     --variable D0 : std_logic_vector(data_width-1 downto 0);
    begin
        if (clkB'event and clkB='1') then
            Q <= D1;
        end if;
    end process;
    
end behv;

