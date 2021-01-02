library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package bus_multiplexer_pkg is
    type bus_array is array(natural range <>) of std_logic_vector;
end package;

----------------------------------------------------------------------------------
-- Author : R. Stephenson
-- Description : Pre-buffer to hold multiple spectrum data and handle CDC
-- from data to ethernet. Data takes out spectrums and holds until ethernet is ready
-- to accept a new spectrum in the ethernet's internal buffer/table to be offloaded
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.bus_multiplexer_pkg.all;


entity pre_data_buffer is -- (FIFO)
    generic(
        N   : integer := 8; -- input data width
        data_points  : integer := 9;  -- BINS*PFB_bitwidth/8 "data points"
        N_specs : integer := 4 -- 2^Number of saved spectrums in table 
    );
    port(
        data_clk        : in std_logic;
        eth_clk         : in std_logic;
        sclr_n          : in std_logic;   
        data_in         : in bus_array(0 to data_points)(N-1 downto 0);
        wready, rready  : in std_logic;
        
        data_out        : out bus_array(0 to data_points)(N-1 downto 0);
        empty           : out std_logic;
        full            : out std_logic;
        wvalid,rvalid   : out std_logic;
        fill_count      : out integer range N_specs downto 0
    );
end pre_data_buffer;

architecture behavioral of pre_data_buffer is 
    type bus_table is array(0 to N_specs) of bus_array(0 to data_points)(N-1 downto 0);
    signal data_buffer  : bus_table; -- spectrum data held here   

    -- internal signals
    signal empty_i      : std_logic; 
    signal full_i       : std_logic;
    signal fill_count_i : integer range N_specs downto 0; 

    subtype index_type is integer range N_specs downto 0;
    signal head_i      : index_type; 
    signal tail_i      : index_type;

    procedure incr(signal index : inout index_type) is
        begin
        if index = index_type'high then
            index <= index_type'low;
        else
            index <= index + 1;
        end if;
    end procedure;
begin 

    empty <= empty_i;
    full <= full_i;
    fill_count <= 0 when sclr_n='0' else fill_count_i;

    empty_i <= '1' when fill_count_i = 0 else '0';
    full_i <= '1' when fill_count_i >= N_specs else '0';

    read_spec : process(data_clk) 
    begin
        if (data_clk'event and data_clk='1') then 
            if (sclr_n='0') then 
                data_buffer <= (others=>(others=>(others=>'0')));
            else
                if (full_i='0') then 
                    rvalid<='1';
                    if (rready='1') then
                        data_buffer(head_i) <= data_in;
                        incr(head_i);
                    else
                        NULL;
                    end if;
                end if;
            end if;
        end if;
    end process;

    write_spec :  process(eth_clk) 
    begin
        if (eth_clk'event and eth_clk='1') then 
            if (empty_i='0') then 
                wvalid <='1';
                if (wready='1') then
                    data_out <= data_buffer(tail_i);
                    incr(tail_i);
                else 
                    NULL;
                end if;
            end if;
        end if;
    end process;
    
    -- update_fill : process(fill_count_i, count_i)
    -- begin 
    --     if (fill_count_i = 0) then
    --         empty_i<='1';
    --     elsif (fill_count_i = N_specs) 
    --         full_i<='1';
    --     else
    --         empty_i<='0';
    --         full_i<='0';
    --     end if;
    -- end process;

    update_fill_count : process(head,tail)
    begin
        if head < tail then 
            fill_count_i <= head - tail + N_specs;
        else 
            fill_count_i <= head - tail;
        end if;
    end process;
end behavioral;