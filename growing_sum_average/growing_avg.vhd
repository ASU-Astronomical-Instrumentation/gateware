library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity growing_avg is 
    generic(         N : integer := 16;
                N_AVGS : integer := 1;  -- Total Averages = 2^N_AVGS -1
             SUM_WIDTH : integer := 128  -- Upper limit for possible number of averages (= S_W^2 - N)
    );
    port(
        clk : in std_logic;
      valid : in std_logic;
          x : in std_logic_vector(N-1 downto 0);
  N_AVGS_in : in std_logic_vector(3-1 downto 0);
    new_dat : out std_logic;     
          y : out std_logic_vector(N-1 downto 0)
    );
end growing_avg;

architecture behv of growing_avg is 
    signal sum  : unsigned(SUM_WIDTH-1 downto 0); 
    signal sum_out  : unsigned(SUM_WIDTH-1 downto 0); -- init signal for sim
    signal first_val  : unsigned(SUM_WIDTH-1 downto 0);
    signal adds : unsigned(SUM_WIDTH-1 downto 0); -- number of additons performed
    signal result : std_logic_vector(N-1 downto 0);
begin 
    
    acc : process(clk, rdy, N_AVGS_in) --accumulation
    begin 
        if (clk'event and clk='1') then  
                new_data <='0'; 
                if (valid='1') then
                    if (adds = 0) then
                        sum <=  first_val + unsigned((SUM_WIDTH-1 downto x'length => '0') & x);
                        adds <= (SUM_WIDTH-1 downto 1 => '0') & '1'; -- (0 => '1', others =>'0')
                    elsif (adds < 2**(to_integer(unsigned(N_AVGS_in))) -1) then -- continue accumulation until max average # is reached
                        sum <= sum + unsigned((SUM_WIDTH-1 downto x'length => '0') & x); -- sum = sum + x
                        adds <= adds + 1;   
                    else    
                        adds <= (others => '0');
                        first_val <= unsigned((SUM_WIDTH-1 downto x'length => '0') & x);
                        sum_out <= sum;
                        new_dat <= '1';
                    end if;
                else 
                        sum_out <= (others => '0');
                        sum <= (others => '0');
                        adds <= (others => '0');
                        first_val <= (others => '0');
                end if;
        end if;   
    end process;

    -- synthesized with lut, not a end path for next FF. May rise issues in critical timing path.
    div : process(clk, sum_out)  
        if (clk'event and clk='1') then
            result <= std_logic_vector(sum_out(N+to_integer(unsigned(N_AVGS_in))-1 downto to_integer(unsigned(N_AVGS_in)))); -- divide and slice
            y <= result;          
        end if;
    end process;

end behv;

-- Notes, Overflow
-- sum <= ('0' & operand1) + ('0' & operand2);
-- sum <= (operand1(N-1) & operand1) + (operand2(N-1) & operand2);

-- sum <= (operand1(N-1) & '0' & operand1) + (operand2(N-1) & '0' & operand2);

-- overflow_flag <= sum(n-2)
-- operand = 7 bits
-- sum = 9 bits

-- VHDLwhiz random verification

-- https://www.adiuvoengineering.com/blog/categories/microzed-chronicles (past 4 articles)
-- https://vhdlwhiz.com/constrained-random-verification/

-- https://vhdlwhiz.com/ring-buffer-fifo/ (might not be ideal for higher clock rates)

