library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GSP_MMIO_v1_0_S00_AXI is
	generic (
        N : INTEGER := 17; -- # of counter bits (for a counter length 2^N)
		M : INTEGER := 32; -- Data width of a the data
		W : INTEGER := 1; -- Number of data points present in a memory location (used to cast data to memory)
		LD : STD_LOGIC := '1'; -- MMIO config Read/~Write from BRAM Module 
		DATA_WIDTH	: INTEGER	:= 32
	);
	port (
        reg0, reg1, reg2, reg3 : in std_logic_vector(DATA_WIDTH-1 downto 0);

        gpo   : out std_logic_vector(N-1 downto 0);
        read  : in std_logic_vector(M-1 downto 0); -- this is used to attach axi to data
        write : out std_logic_vector( (W*M)-1 downto 0);
        
        inA : out std_logic;
        inB : out std_logic;
        count : out std_logic_vector(N-1 downto 0);
        done : out std_logic;
        
        UBC_clk : in std_logic
	);
end GSP_MMIO_v1_0_S00_AXI;

architecture arch_imp of GSP_MMIO_v1_0_S00_AXI is
    signal hold : std_logic;
    signal dat : std_logic_vector(N-1 downto 0);
begin
    gpo <= reg0(N-1 downto 0);
    inA <= reg1(1); -- clear count value 
    inB <= reg1(2);
   
    write <=  reg3(M-1 downto 0); 
    count <= dat;
    done <= hold; --holding max count flag (done writing values to bream)
   
    UBC1 : entity work.UBC(behavioral)
    generic map(N => N) --dont ask
    port map(
        clk => UBC_clk, 
        clr => reg1(0), -- where clear count value is set
        enb => hold, --PLACE HOLDER
        Q => dat
   );
   
   CMP1 : entity work.CMP2(behavioral)
   generic map (N => N, LOAD => LD)
   port map (
        count_val => dat,
        Q => hold 
   );

end arch_imp;
