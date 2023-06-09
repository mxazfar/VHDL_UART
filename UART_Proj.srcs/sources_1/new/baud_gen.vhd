library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Baud Generator setup for 50 MHz clock @ 19200 baud

entity baud_gen is
    generic(
        N: integer := 9;
        M: integer := 164
    );
    
    port(
        clk, reset: in std_logic;
        max_tick: out std_logic;
        q: out std_logic_vector(N-1 downto 0)
    );
end baud_gen;

architecture arch of baud_gen is
    signal r_reg: unsigned(N-1 downto 0);
    signal r_next: unsigned(N-1 downto 0);
    
    begin
    
    process(clk, reset)
    begin
        if (reset = '1') then
            r_reg <= (others => '0');
        elsif (clk'event and clk='1') then
            r_reg <= r_next;
        end if;
    end process;
    
    -- next state logic
    r_next <= (others => '0') when r_reg=(M-1) else r_reg + 1;
    -- output logic
    q <= std_logic_vector(r_reg);
    max_tick <= '1' when r_reg=(M-1) else '0';
end arch;
