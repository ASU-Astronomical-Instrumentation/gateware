library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity compare is
    generic (width : integer := 32);
    Port ( 
            A : in STD_LOGIC_VECTOR(width-1 downto 0);
            B : in STD_LOGIC_VECTOR(width-1 downto 0);
            C : out STD_LOGIC
          );
end compare;

architecture rtl of compare is
begin
    C <= '1' when (unsigned(B) >= unsigned(A)) else '0';
end architecture;
