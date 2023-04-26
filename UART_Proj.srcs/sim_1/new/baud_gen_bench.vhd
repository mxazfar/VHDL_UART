library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

--Testbench file for simulating UART setup with flag FF buffer

entity baud_gen_bench is
--  Port ( );
end baud_gen_bench;

architecture Behavioral of baud_gen_bench is
    --Baud Gen Stuff
    signal clk: std_logic := '0';
    signal reset: std_logic := '1';
    signal max_tick: std_logic;
    signal q : std_logic_vector(9-1 downto 0);
     
    component baud_gen port(
        clk, reset: in std_logic;
        max_tick: out std_logic;
        q: out std_logic_vector(9-1 downto 0)
    );
    end component;    
begin

u0: baud_gen port map(
    clk => clk,
    reset => reset,
    max_tick => max_tick,
    q => q
);

reset <= '0';
clk <= not clk after 10ns;

end Behavioral;
