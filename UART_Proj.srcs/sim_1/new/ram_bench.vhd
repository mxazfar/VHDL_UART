library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ram_bench is
--  Port ( );
end ram_bench;

architecture Behavioral of ram_bench is

signal w : integer := 8; -- number of bits per RAM word
signal r : integer := 9; -- number of words in RAM

signal clk : std_logic := '1';
signal wr : std_logic;
signal rd : std_logic;
signal addr : std_logic_vector(r-1 downto 0);
signal di : std_logic_vector(w-1 downto 0);
signal do : std_logic_vector(w-1 downto 0);

begin

u0: entity Work.ram(behavioral) port map(
    clk => clk,
    wr => wr,
    rd => rd,
    addr => addr,
    di => di,
    do => do
);

clk <= not clk after 10ns;

process begin

addr <= "000000001";
di <= x"AB";
wait for 5ns;

wr <= '1';
wait for 50ns;
wr <= '0';

wait for 200ns;

addr <= "000000010";
di <= x"FC";
wait for 5ns;

wr <= '1';
wait for 50ns;
wr <= '0';

wait for 200ns;

addr <= "000000011";
di <= x"CB";
wait for 5ns;

wr <= '1';
wait for 50ns;
wr <= '0';

wait for 200ns;



addr <= "000000001";
wait for 5ns;

rd <= '1';
wait for 100ns;
rd <= '0';

wait for 200ns;

addr <= "000000010";
wait for 5ns;

rd <= '1';
wait for 100ns;
rd <= '0';

wait for 200ns;

addr <= "000000011";
wait for 5ns;

rd <= '1';
wait for 100ns;
rd <= '0';

wait for 200ns;



wait for 5ms;

end process;

end Behavioral;
