-- Ryan Stephenson 03-27-20 
-- Average and Downsample
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity AVGDOWNrev_i is 
    generic(
        N : integer := 14
    );
    port(
        clk : in std_logic;
        ready : in std_logic;
        valid : out std_logic;
        rst: in std_logic;
        x : in std_logic_vector(N-1 downto 0);
        y : out std_logic_vector(N-1 downto 0)
    );
end AVGDOWNrev_i;

architecture behv of AVGDOWNrev_i is 
    type STATE_LOGIC is (load0, eval);
begin 
    process(rst,clk,x)
        variable val0 : std_logic_vector(N-1 downto 0);
        variable tmpr1 : std_logic_vector(N downto 0);
        variable tmpr : std_logic_vector(N-1 downto 0);
        variable tmp : std_logic; 
        variable state, next_state : STATE_LOGIC; 
    begin
        if(rst='1') then 
            tmp := '0';
            tmpr := (others => '0');
            tmpr1 := (others => '0');
            state := load0;
            next_state := load0;
        elsif (clk'event and clk='1') then 
            tmp := '0';
            state := next_state;
            if (ready='1') then
                case state is
                    when load0 =>
                        val0 := x;
                        next_state := eval;
                    when eval =>
                        tmpr1 :=  std_logic_vector((signed(val0(N-1) & val0) + signed(x(N-1) & x))/2);
                        tmpr := tmpr1(N) & tmpr1(N-2 downto 0);
                        tmp := '1';
                        next_state := load0;
                end case;
            end if;
        end if;
        y <= tmpr;
        valid <= tmp;
    end process;
end behv;