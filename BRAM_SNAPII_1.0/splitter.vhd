library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keeper is 
    generic( slots : integer := 8;
			 data_width : integer := 32);
    port(
		clk : in std_logic;
		--sel : in std_logic; --NormalOP/~Transparent
		sel : in std_logic_vector(3 downto 0);
		Q : out std_logic_vector(data_width-1 downto 0);
		D : in std_logic_vector((data_width*slots)-1 downto 0)
	);
end keeper;


architecture behv of keeper is 
    alias D0 : std_logic_vector(data_width-1 downto 0) is D((data_width*1)-1 downto data_width*0);
    alias D1 : std_logic_vector(data_width-1 downto 0) is D((data_width*2)-1 downto data_width*1);
    alias D2 : std_logic_vector(data_width-1 downto 0) is D((data_width*3)-1 downto data_width*2);
    alias D3 : std_logic_vector(data_width-1 downto 0) is D((data_width*4)-1 downto data_width*3);
    alias D4 : std_logic_vector(data_width-1 downto 0) is D((data_width*5)-1 downto data_width*4);
    alias D5 : std_logic_vector(data_width-1 downto 0) is D((data_width*6)-1 downto data_width*5);
    alias D6 : std_logic_vector(data_width-1 downto 0) is D((data_width*7)-1 downto data_width*6);
    alias D7 : std_logic_vector(data_width-1 downto 0) is D((data_width*8)-1 downto data_width*7);
begin 
    process (clk,D,sel)
    begin
        if (clk'event and clk='1') then
        case SEL is 
            when X"0" =>    Q <= D0;
            when X"1" =>    Q <= D1;
            when X"2" =>    Q <= D2;
            when X"3" =>    Q <= D3;
            when X"4" =>    Q <= D4;
            when X"5" =>    Q <= D5;
            when X"6" =>    Q <= D6;
            when X"7" =>    Q <= D7;
            when others =>  Q <= X"deadbeef";
        end case;
        end if;
    end process;
end behv;

