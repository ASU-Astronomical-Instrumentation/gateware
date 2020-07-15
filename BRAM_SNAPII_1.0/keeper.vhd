library ieee;
use ieee.std_logic_1164.all;
use iee.numeric_std.all;

entity keeper is
    generic(      slots : integer := 8;
             data_width : integer := 32 );
    port(
         clk : in std_logic;
        sclr : in std_logic; --NormalOP/~Transparent
        send : in std_logic;
        addr : in std_logic_vector(8 downto 0);
           D : in std_logic_vector(data_width-1 downto 0);
           Q : out std_logic_vector((data_width*slots)-1 downto 0)
);
end keeper;

architecture behv of keeper is
begin
    process (clk,enb,D,addr,send)
        variable reg_0x0 : std_logic_vector(data_width-1 downto 0);
        variable reg_0x1 : std_logic_vector(data_width-1 downto 0);
        variable reg_0x2 : std_logic_vector(data_width-1 downto 0);
        variable reg_0x3 : std_logic_vector(data_width-1 downto 0);
        variable reg_0x4 : std_logic_vector(data_width-1 downto 0);
        variable reg_0x5 : std_logic_vector(data_width-1 downto 0);
        variable reg_0x6 : std_logic_vector(data_width-1 downto 0);
        variable reg_0x7 : std_logic_vector(data_width-1 downto 0);
        --variable reg_0x8 : std_logic_vector(data_width-1 downto 0);
        --variable reg_0x9 : std_logic_vector(data_width-1 downto 0);
        --variable reg_0xA : std_logic_vector(data_width-1 downto 0);
        --variable reg_0xB : std_logic_vector(data_width-1 downto 0);
        --variable reg_0xC : std_logic_vector(data_width-1 downto 0);
        --variable reg_0xD : std_logic_vector(data_width-1 downto 0);
        --variable reg_0xE : std_logic_vector(data_width-1 downto 0);
        --variable reg_0xF : std_logic_vector(data_width-1 downto 0);
    begin
        if (clk'event and clk='1') then
            if (sclr='1') then
                Q <= (others=>'0');
            elsif (send='1') then
                Q <= reg7 & reg6 & reg5 & reg4 & reg3 & reg2 & reg1 & reg0;
            else
                Q <= (others=>'0');
                case ADDR is
                    when X"0" =>  reg_0x0 <= D;
                    when X"1" =>  reg_0x1 <= D;
                    when X"2" =>  reg_0x2 <= D;
                    when X"3" =>  reg_0x3 <= D;
                    when X"4" =>  reg_0x4 <= D;
                    when X"5" =>  reg_0x5 <= D;
                    when X"6" =>  reg_0x6 <= D;
                    when X"7" =>  reg_0x7 <= D;
                    --when X"8" =>  reg_0x8 <= ;
                    --when X"9" =>  reg_0x9 <= ;
                    --when X"a" =>  reg_0xA <= ;
                    --when X"b" =>  reg_0xB <= ;
                    --when X"c" =>  reg_0xC <= ;
                    --when X"d" =>  reg_0xD <= ;
                    --when X"e" =>  reg_0xE <= ;
                    --when X"f" =>  reg_0xF <= ;
                    when others => reg0 <= X"deadbeef";
                end case;
            end if;
        end if;
    end process;
end behv;