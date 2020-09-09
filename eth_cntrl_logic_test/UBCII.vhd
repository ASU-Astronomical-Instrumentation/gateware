library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UBCII is
    generic (width : integer := 32);
    Port (  clk, clr, enb : in STD_LOGIC; 
            n : in STD_LOGIC_VECTOR(width-1 downto 0);
            Q : out STD_LOGIC_VECTOR(width-1 downto 0)
          );
end UBCII;

architecture behav of UBCII is
begin
    process (clk,clr,enb) 
        variable val : unsigned(width-1 downto 0);
    begin 
        if (clr='1') then 
            val := (others => '0');
        elsif (rising_edge(clk)) then
            if (enb='1') then 
                if (val <= unsigned(n)) then
                    val := val + 1; --count while bellow threshold n
                else 
                    val := (others => '0');
                end if;
            end if;
        end if;
        Q <= std_logic_vector(val);
    end process;
end architecture;
