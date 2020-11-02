library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ring_buffer is 
      generic( 	
        RAM_WIDTH : natural := 8;
        RAM_DEPTH : natural := 1024 );
    port( 
        wclk    : in std_logic;
        rclk    : in std_logic;
        rst     : in std_logic;

        -- Write Port
        wr_en : in std_logic;
        wr_data : in std_logic_vector(8-1 downto 0);

        -- Read Port
        rd_en : in std_logic;
        rd_valid : out std_logic;
        rd_data : out std_logic_vector(8-1 downto 0);

        -- Flags
        emptied, empty_next : out std_logic;
        filled, full_next   : out std_logic;

        -- The number of elements in the FIFO
        fill_count : out integer range RAM_DEPTH - 1 downto 0
    );
end ring_buffer;


architecture behavior of ring_buffer is 
    type ram_type is array(0 to RAM_DEPTH-1) of std_logic_vector(7 downto 0); 
    signal ram : ram_type;

    subtype index_type is integer range ram_type'range;
    signal head : index_type;
    signal tail : index_type;

    signal empty_i : std_logic; -- _i for internal use, for inout in procedure
    signal full_i : std_logic;
    signal fill_count_i : integer range RAM_DEPTH - 1 downto 0;

    -- Increment and wrap
    procedure incr(signal index : inout index_type) is
        begin
        if index = index_type'high then
            index <= index_type'low;
        else
            index <= index + 1;
        end if;
    end procedure;
begin 
    emptied <= empty_i;
    filled <= full_i;
    fill_count <= fill_count_i;
    
    -- Set the flags
    empty_i <= '1' when fill_count_i = 0 else '0';
    empty_next <= '1' when fill_count_i <= 1 else '0';
    full_i <= '1' when fill_count_i >= RAM_DEPTH - 1 else '0';
    full_next <= '1' when fill_count_i >= RAM_DEPTH - 2 else '0';

    update_head : process(wclk)
    begin 
        if (wclk'event and wclk='1') then
            if rst='1' then
                head <= 0;
            else 
                if wr_en='1' and full_i='0' then 
                    incr(head);
                end if;
            end if;
        end if;
    end process;

    update_tail : process(rclk)
    begin 
        if (rclk'event and rclk='1') then
            if rst='1' then 
                tail <= 0;
                rd_valid <= '0';
            else 
                rd_valid <= '0';
                if rd_en='1' and empty_i='0' then 
                    incr(tail);
                    rd_valid <= '1';
                end if;
            end if;
        end if;
    end process;

    write_ram : process(wclk)
    begin
        if (wclk'event and wclk='1') then
            ram(head) <= wr_data;
        end if;
    end process;

    read_ram: process(rclk)
    begin
    if (rclk'event and rclk='1') then
        rd_data <= ram(tail);
    end if;
    end process;


    update_fill_count : process(head,tail)
    begin
        if head < tail then 
            fill_count_i <= head - tail + RAM_DEPTH;
        else 
            fill_count_i <= head - tail;
        end if;
    end process;
end behavior;
