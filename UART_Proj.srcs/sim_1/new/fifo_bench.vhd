library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

--Testbench for simulating FIFO

entity fifo_bench is
end fifo_bench; 

architecture sim of fifo_bench is

constant W : natural := 8;

--FIFO Signals
    signal clk : std_logic := '1';
    signal reset : std_logic := '1';
    signal w_data: std_logic_vector(W-1 downto 0);
    signal wr: std_logic;
    signal rd: std_logic;
    signal r_data: std_logic_vector(W-1 downto 0);
    signal fifo_full: std_logic;
    signal fifo_empty: std_logic;
    signal num_elem : std_logic_vector(1 downto 0);

begin

reset <= '0';
clk <= not clk after 10ns;

u0: entity Work.interface_fifo(Behavioral) port map(
    clk => clk,
    reset => reset,
    w_data => w_data,
    wr => wr,
    rd => rd,
    r_data => r_data,
    fifo_full => fifo_full,
    fifo_empty => fifo_empty, 
    num_elem => num_elem
);

process begin

wait for 10ns;

w_data <= "10100101";

wait for 100ns;
wr <= '1';
wait for 20ns;
wr <= '0';

w_data <= "01010101";

wait for 100ns;
wr <= '1';
wait for 20ns;
wr <= '0';

w_data <= "11110000";

wait for 100ns;
wr <= '1';
wait for 20ns;
wr <= '0';

w_data <= "10101010";

wait for 100ns;
wr <= '1';
wait for 20ns;
wr <= '0';

wait for 100ns;
rd <= '1';
wait for 20ns;
rd <= '0';

wait for 100ns;
rd <= '1';
wait for 20ns;
rd <= '0';

wait for 100ns;
rd <= '1';
wait for 20ns;
rd <= '0';

wait for 100ns;
rd <= '1';
wait for 20ns;
rd <= '0';



end process;

end architecture;