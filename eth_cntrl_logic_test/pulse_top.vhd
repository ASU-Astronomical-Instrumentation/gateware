library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pulse_top is
    generic (N : integer := 32);
    Port (  clk, rst, enb : in STD_LOGIC; 
            n : in STD_LOGIC_VECTOR(N-1 downto 0);
            M : in STD_LOGIC_VECTOR(N-1 downto 0);
            valid : out STD_LOGIC;
            last : out std_logic
          );
end pulse_top;

architecture struct of pulse_top is
    signal count_out : STD_LOGIC_VECTOR(N-1 downto 0);
    signal B_gt_A : STD_LOGIC;
begin
    ADDER : entity work.UBC(behv)
    generic map (N => N);
    port map (
        clk => clk,
        clr => rst,
        enb => enb,
        n => n,
        Q => count_out
    );

    CMP : entity work.compare(behv) 
    generic map (N => N);
    prot map (
        A => count_out,
        B => M,
        C => B_gt_A
    );

    process (clk, clr, enb) is 
        signal D1 : STD_LOGIC;
    begin 
        if (clk'event and clk='1') then 
            D1 <= B_gt_A;
    end process;

    process (clk, clr, enb) is 
    signal D2 : STD_LOGIC;
    begin 
    if (clk'event and clk='1') then 
        D2 <= D1;
    end process;


    valid <= D2;
    last <= D1 and not B_gt_A; -- pulse on falling edge

end architecture;
