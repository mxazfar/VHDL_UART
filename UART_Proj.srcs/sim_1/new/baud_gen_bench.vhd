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
    signal max_tick: std_logic;
    signal q : std_logic_vector(9-1 downto 0);
    
    --TX stuff
    signal din: std_logic_vector(7 downto 0);
    signal tx_done: std_logic;
    signal tx: std_logic; 
    
    --RX stuff
    signal dout_rx : std_logic_vector (7 downto 0);
    signal rx_done_tick : std_logic;
    
    --TX Interface
    signal w_data : std_logic_vector(7 downto 0);
    signal wr_uart : std_logic := '0';
    signal tx_full : std_logic;
    
    --RX Interface
    signal r_data : std_logic_vector(7 downto 0);
    signal rd_uart : std_logic;
    signal rx_empty : std_logic;  
      
    component baud_gen port(
        clk, reset: in std_logic;
        max_tick: out std_logic;
        q: out std_logic_vector(9-1 downto 0)
    );
    end component;
    
    component uart_rx port(
        clk, reset: in std_logic;
        rx: in std_logic;
        s_tick: in std_logic;
        
        rx_done_tick: out std_logic;
        dout: out std_logic_vector(7 downto 0)
    );
    end component;
    
    component uart_tx port(
        clk, reset: in std_logic;
        tx_start: in std_logic;
        s_tick: in std_logic;
        din: in std_logic_vector(7 downto 0);
        tx_done_tick: out std_logic;
        tx: out std_logic
    );
    end component; 
       
    component interface_tx port(
        clk, reset: in std_logic;
        clr_flag, set_flag: in std_logic;
       -- en : in std_logic;
        din: in std_logic_vector(8-1 downto 0);
        dout: out std_logic_vector(8-1 downto 0);
        flag: out std_logic
    ); 
    end component;     
begin

u0: baud_gen port map(
    clk => clk,
    reset => reset,
    max_tick => max_tick,
    q => q
);

u_tx_interface: interface_tx port map(
    clk => clk,
    reset => reset,
    clr_flag => tx_done,
    set_flag => wr_uart,
    din => w_data,
    dout => din,
    flag => tx_full 
);

u_tx: uart_tx port map(
    clk => clk,
    tx_start => tx_full,
    reset => reset,
    s_tick => max_tick,
    din => din,
    tx_done_tick => tx_done,
    tx => tx
);

u_rx_interface: interface_tx port map(
    clk => clk,
    reset => reset,
    clr_flag => rx_done_tick, 
    set_flag => rd_uart,
    din => dout_rx,
    dout => r_data,
    flag => rx_empty 
);

u_rx : uart_rx port map(
    clk => clk,
    reset => reset,
    rx => tx,
    s_tick => max_tick,
    rx_done_tick => rx_done_tick,
    dout => dout_rx    
);

reset <= '0';
clk <= not clk after 10ns;

process 
begin

wait for 10ns;
w_data <= "10110101";

wait for 1ms;
wr_uart <= '1';
wait for 100ns;
wr_uart <= '0';

wait for 0.6ms;

rd_uart <= '1';
wait for 100ns;
rd_uart <= '0';

wait for 5ms;

end process;

end Behavioral;
