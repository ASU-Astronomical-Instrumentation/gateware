library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity growing_avg is 
    generic(         N : integer := 16;
              MAX_AVGS : integer := 6;  -- must be base 2
             SUM_WIDTH : integer := 128  -- Upper limit for possible number of averages (= S_W^2 - N)
    );
    port(
        clk : in std_logic;
          x : in std_logic_vector(N-1 downto 0);
          y : out std_logic_vector(N-1 downto 0)
    );
end growing_avg;

architecture behv of growing_avg is 
    signal sum  : unsigned(SUM_WIDTH-1 downto 0);
    signal sum_out  : unsigned(SUM_WIDTH-1 downto 0);
    signal AVGS : unsigned(SUM_WIDTH-1 downto 0);
    signal result : std_logic_vector(N-1 downto 0);
begin 
    
    acc : process(clk)
    begin 
        if (clk'event and clk='1') then
            if (AVGS < 2**MAX_AVGS) then
                sum <= sum + unsigned((SUM_WIDTH-1 downto x'length => '0') & x);
                AVGS <= AVGS + 1;
            else 
                AVGS <= (others => '0');
                sum <= (others => '0');
                sum_out <= sum;
            end if;
        end if;
    end process;
 
    result <= std_logic_vector(sum_out(N+MAX_AVGS-1 downto MAX_AVGS));
    y <= result;

end behv;