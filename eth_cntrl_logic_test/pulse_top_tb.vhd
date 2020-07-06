library ieee; use ieee.std_logic_1164.all;
entity pulse_top_tb is
  generic ( width : positive := 12); -- total bit width
end entity pulse_top_tb;

architecture test of pulse_top_tb is
  signal Tsym_in  : std_logic_vector(width-1 downto 0);
  signal Nsym_in  : std_logic_vector(width-1 downto 0);
  signal en       : std_logic;
  signal reset    : std_logic;
  signal clk      : std_logic;
  signal SymTrans : std_logic;
  signal SymNum   : std_logic_vector(width-1 downto 0);
begin
  dut : entity work.pulse_top(struct)
    generic map (width=>width)
    port map ( Tsym_in, Nsym_in, en, clk, reset, SymTrans, SymNum); -- signal names, order dep.
  
  -- continuous clock
  process 
    begin
      clk <= '0';
      wait for 2 ns;
      clk <= '1';
      wait for 2 ns;
  end process;

  process
    begin
      Tsym_in <= X"014";
      Nsym_in <= X"004";
      reset <= '1';
      en <= '0';
      wait for 5 ns;
      reset <= '0';
      en <= '1';
      wait for 30 ns;
      reset <= '1';
      wait for 2 ns;
      reset <= '0';
  wait;
  end process;

end architecture test; 
