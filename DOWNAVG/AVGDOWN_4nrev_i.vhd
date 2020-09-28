library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


entity AVGDOWN_4nrev_i is 
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
end AVGDOWN_4nrev_i;


architecture twostack_arch of AVGDOWN_4nrev_i is
    signal valid0,valid1 :  std_logic;
    signal yA,yB :  std_logic_vector(N-1 downto 0);
begin
    stage_1 : entity work.AVGDOWNrev_i(behv)
    generic map (N=>N)
    port map (
        clk=>clk,
        ready=>ready,
        valid=>valid0,
        rst=>rst,
        x=>x,
        y=>yA 
    );


    stage_2 : entity work.AVGDOWNrev_i(behv)
    generic map (N=>N)
    port map (
        clk=>clk,
        ready=>valid0,
        valid=>valid1,
        rst=>rst,
        x=>yA,
        y=>yB 
    );

    valid <= valid1;
    y <= yB;

end  twostack_arch; -- 
