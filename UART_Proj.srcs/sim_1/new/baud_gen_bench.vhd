library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity baud_gen_bench is
--  Port ( );
end baud_gen_bench;

architecture Behavioral of baud_gen_bench is
    --Baud Gen Stuff
    signal clk: std_logic := '0';
    signal reset: std_logic := '1';
   
    --RX Stuff
    signal rx: std_logic := '1';
    signal s_tick: std_logic;
    signal rx_done_tick: std_logic;
    signal dout: std_logic_vector(7 downto 0);
    
    component baud_gen port(
        clk, reset: in std_logic;
        max_tick: out std_logic;
        q: out std_logic_vector(5-1 downto 0)
    );
    end component;
    
begin

u0: baud_gen port map(
    clk => clk,
    reset => reset,
    max_tick => s_tick
);

rx_t: entity Work.uart_rx(arch) port map(
   clk => clk,
   reset => reset,
   s_tick => s_tick,
   rx => rx,
   rx_done_tick => rx_done_tick,
   dout => dout 
);

reset <= '0';
clk <= not clk after 31.25ps;

process begin

wait for 16ns;
rx <= '0';

wait for 16ns;
rx <= '1';
wait for 16ns;
rx <= '1';
wait for 16ns;
rx <= '0';
wait for 16ns;
rx <= '1';
wait for 16ns;
rx <= '0';
wait for 16ns;
rx <= '1';
wait for 16ns;
rx <= '0';
wait for 16ns;
rx <= '1';

end process;

end Behavioral;
