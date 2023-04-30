library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity classifier_bench is
--  Port ( );
end classifier_bench;

architecture Behavioral of classifier_bench is
signal W : natural := 8;

signal clk : std_logic := '1';
signal reset : std_logic := '1';
signal din: std_logic_vector(W-1 downto 0);
signal dout: std_logic_vector(W-1 downto 0);

begin

u0: entity Work.Classifier(Behavioral) port map(
    clk => clk,
    reset => reset,
    din => din,
    dout => dout
);

clk <= not clk after 10ns;
reset <= '0';

process begin

din <= x"E1";
wait for 1000ns;

din <= x"C1";
wait for 1000ns;

din <= x"A1";
wait for 1000ns;

din <= x"81";
wait for 1000ns;

din <= x"61";
wait for 1000ns;

din <= x"41";
wait for 1000ns;

din <= x"21";
wait for 1000ns;

din <= x"11";
wait for 1000ns;


end process;

end Behavioral;
