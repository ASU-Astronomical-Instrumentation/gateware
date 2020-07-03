library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UBC is
    generic (N : integer := 13);
    Port (  clk, clr, enb : in STD_LOGIC; 
            Q : out STD_LOGIC_VECTOR(N-1 downto 0)
          );
end UBC;

architecture Behavioral of UBC is
begin
    process (clk,clr,enb) 
        variable val : unsigned(N-1 downto 0);
    begin 
        if (clr='1') then 
            val := (others => '0');
        elsif (rising_edge(clk)) then
            if (enb='1') then 
                val := val + 1;
            end if;
        end if;
        Q <= std_logic_vector(val);
    end process;
end architecture;