library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


entity AVGDOWN_1024nrev_i is 
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
end AVGDOWN_1024nrev_i;


architecture bigstack_arch of AVGDOWN_1024nrev_i is
    signal valid0,valid1,valid2,valid3,valid4 :  std_logic;
    signal y0,y1,y2,y3,y4 :  std_logic_vector(N-1 downto 0);
begin


    stage_1 : entity work.AVGDOWN_4nrev_i(twostack_arch)
    generic map (N=>N)
    port map (
        clk=>clk,
        ready=>ready,
        valid=>valid0,
        rst=>rst,
        x=>x,
        y=>y0 
    );


    stage_2 : entity work.AVGDOWN_4nrev_i(twostack_arch)
    generic map (N=>N)
    port map (
        clk=>clk,
        ready=>valid0,
        valid=>valid1,
        rst=>rst,
        x=>y0,
        y=>y1 
    );
    stage_3 : entity work.AVGDOWN_4nrev_i(twostack_arch)
    generic map (N=>N)
    port map (
        clk=>clk,
        ready=>valid1,
        valid=>valid2,
        rst=>rst,
        x=>y1,
        y=>y2 
    );

    stage_4 : entity work.AVGDOWN_4nrev_i(twostack_arch)
    generic map (N=>N)
    port map (
        clk=>clk,
        ready=>valid2,
        valid=>valid3,
        rst=>rst,
        x=>y2,
        y=>y3 
    );    

    stage_5 : entity work.AVGDOWN_4nrev_i(twostack_arch)
    generic map (N=>N)
    port map (
        clk=>clk,
        ready=>valid3,
        valid=>valid4,
        rst=>rst,
        x=>y3,
        y=>y4 
    ); 
    
    valid <= valid4;
    y <= y4;

end  bigstack_arch; -- 
