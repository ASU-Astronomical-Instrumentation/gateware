library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package bus_multiplexer_pkg is
    type bus_array is array(natural range <>) of std_logic_vector;
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.bus_multiplexer_pkg.all;

entity pre_data_buffer_tb is
end pre_data_buffer_tb;

architecture testbench of pre_data_buffer_tb is 
    constant N   : integer := 8; -- input data width
    constant data_points  : integer := 9;  -- BINS*PFB_bitwidth/8 "data poin
    constant N_specs : integer := 4 -- 2^Number of saved spectrums in table 

    signal data_clk         : std_logic;
    signal eth_clk          : std_logic;
    signal sclr_n           : std_logic;
    signal data_in          : bus_array(0 to data_points)(N-1 downto 0);
    signal wready, rready   : std_logic;
        
    signal data_out         : bus_array(0 to data_points)(N-1 downto 0);
    signal empty            : std_logic;
    signal full             : std_logic;
    signal wvalid,rvalid    : std_logic;
    signal fill_count       : std_logic_vector(N_specs downto 0);

    component pre_data_buffer 
    generic(
        N   : integer := 8; -- input data width
        data_points  : integer := 5;  -- BINS*PFB_bitwidth/8 "data points"
        N_specs : integer := 3 -- 2^Number of saved spectrums in table 
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
        fill_count      : out std_logic_vector(N_specs downto 0)
    );
    end component;
begin

dut : pre_data_buffer
generic map( N=>N, data_points=>data_points, N_specs=>N_specs )
port map(
    data_clk   => data_clk,    
    eth_clk    => eth_clk,     
    sclr_n     => sclr_n,      
    data_in    => data_in,     
    wready     => wready,    
    rready     => rready,    
    data_out   => data_out,    
    empty      => empty,       
    full       => full,        
    wvalid     => wvalid,    
    rvalid     => rvalid,    
    fill_count => fill_count  
);

eclk_p : process
begin
    eth_clk <= '0';
    wait for 7 ns;
    eth_clk <= '1';
    wait for 7 ns;
end process;

dclk_p : process
begin
    data_clk <= '0';
    wait for 5 ns;
    data_clk <= '1';
    wait for 5 ns;
end process;

------------------------------------------------------------------------------------
--
--  TESTBENCH STARTS HERE   
--
------------------------------------------------------------------------------------
process 

begin 
    sclr_n <= '0';
    wready <= '0';
    rready <= '0';
    data_in<= (X"c0",X"ff",X"ee",X"0f",X"f0");
    wait for 25 ns;

    sclr_n <= '1';
    wait for 20 ns;

    rready <= '1';
    wait for 15 ns;
    
    rready <= '0';
    wready <= '1';
    data_in<= (X"00",X"00",X"00",X"00",X"00");

    wait;
end process;

end testbench;