library ieee; use ieee.std_logic_1164.all;
entity pulse_top_tb is
  generic ( width : positive := 32); -- total bit width
end entity pulse_top_tb;

architecture test of pulse_top_tb is
  signal M_in      : std_logic_vector(width-1 downto 0);
  signal n_in      : std_logic_vector(width-1 downto 0);
  signal valid_out : std_logic;
  signal last_out  : std_logic;
  signal en        : std_logic;
  signal reset     : std_logic;
  signal clk       : std_logic;
begin
  dut : entity work.pulse_top(struct)
    generic map (width=>width)
    port map ( clk, reset, en, n_in, M_in, valid_out, last_out); -- signal names, order dep.
  
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
      n_in <= X"00000008";
      M_in <= X"00000004";
      reset <= '1';
      en <= '0';
      wait for 5 ns;
      reset <= '0';
      en <= '1';
  wait;
  end process;

end architecture test; 
