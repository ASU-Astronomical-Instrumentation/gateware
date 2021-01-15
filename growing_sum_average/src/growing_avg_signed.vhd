library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- TODO : CHANGED TO SIGNED

entity growing_avg_signed is 
    generic(         N : integer := 16;
                --N_AVGS : integer := 8;  -- Total Averages = 2^N_AVGS -1
             SUM_WIDTH : integer := 128  -- Upper limit for possible number of averages (= S_W^2 - N)
    );
    port(
        clk : in std_logic;
      valid : in std_logic;
          x : in std_logic_vector(N-1 downto 0);
  N_AVGS_in : in std_logic_vector(8-1 downto 0);
    new_dat : out std_logic;     
          y : out std_logic_vector(N-1 downto 0)
    );
end growing_avg_signed;

architecture behv of growing_avg_signed is 
    signal sum          : signed(SUM_WIDTH-1 downto 0) := (others=>'0'); 
    signal first_val    : signed(SUM_WIDTH-1 downto 0);
    signal adds         : unsigned(SUM_WIDTH-1 downto 0); -- number of additons performed
begin 
    
    acc : process(clk, valid, N_AVGS_in) --accumulation
    begin 
        if (clk'event and clk='1') then  
            new_dat <='0'; 
            y <= (others => '0'); -- only output new data when new data is valid   
            if (valid='1') then
                if (adds = 0) then
                    sum <=  first_val + signed((SUM_WIDTH-1 downto x'length => '0') & x);
                    adds <= (SUM_WIDTH-1 downto 1 => '0') & '1'; -- (0 => '1', others =>'0')
                elsif (adds < 2**(to_integer(unsigned(N_AVGS_in))) -1) then -- continue accumulation until max average # is reached
                    sum <= sum + signed((SUM_WIDTH-1 downto x'length => '0') & x); -- sum = sum + x
                    adds <= adds + 1;   
                else    
                    adds <= (others => '0');
                    first_val <= signed((SUM_WIDTH-1 downto x'length => '0') & x);
                    new_dat <= '1';
                    -- output --
                    --y <= std_logic_vector( sum(N+to_integer(unsigned(N_AVGS_in))-1 downto to_integer(unsigned(N_AVGS_in))) ); -- unsgined divide and slice
                    y <= std_logic_vector(resize(shift_right(sum, N),N));
                end if;
            end if;
        end if;   
    end process;
end behv;