library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity growing_avg is 
    generic(         N : integer := 16;
                N_AVGS : integer := 1;  -- Total Averages = 2^N_AVGS
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
    signal adds : unsigned(SUM_WIDTH-1 downto 0); -- number of additons performed
    signal result : std_logic_vector(N-1 downto 0);
begin 
    
    acc : process(clk) --accumulation
    begin 
        if (clk'event and clk='1') then
            if (adds < 2**N_AVGS) then -- continue accumulation until max average # is reached
                sum <= sum + unsigned((SUM_WIDTH-1 downto x'length => '0') & x); -- sum = sum + x
                adds <= adds + 1; 
            else 
                adds <= (others => '0');
                sum <= (others => '0');
                sum_out <= sum;
            end if;
        end if;
    end process;
 
    result <= std_logic_vector(sum_out(N+N_AVGS-1 downto N_AVGS)); -- divide and slice
    y <= result;

end behv;