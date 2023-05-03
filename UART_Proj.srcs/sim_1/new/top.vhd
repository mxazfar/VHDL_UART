library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

--Testbench file for simulating UART fully setup
--After an initial transmission, UART loops forever by writing RX classified back into TX

entity top is
--  Port ( );
end top;

architecture Behavioral of top is
    --Baud Gen Stuff
    signal clk: std_logic := '0';
    signal reset: std_logic := '1';
    signal max_tick: std_logic;
    signal q : std_logic_vector(9-1 downto 0);
    
    --TX stuff
    signal din: std_logic_vector(7 downto 0);
    signal tx_done: std_logic;
    signal tx: std_logic; 
    signal tx_start : std_logic;
    
    --RX stuff
    signal dout_rx : std_logic_vector (7 downto 0);
    signal rx_done_tick : std_logic;
    
    --TX Interface
    signal w_data : std_logic_vector(7 downto 0);
    signal wr_uart : std_logic := '0';
    signal wr_tx_fifo : std_logic;
    signal tx_fifo_num : std_logic_vector (1 downto 0);
    
    --RX Interface
    signal r_data : std_logic_vector(7 downto 0);
    signal rd_uart : std_logic;
    signal rx_empty : std_logic;  
    signal rx_fifo_num : std_logic_vector (1 downto 0);
      
    --FIFO RAM 
    signal wr_fifo_ram : std_logic;
    signal rd_fifo_ram : std_logic;
    signal addr_fifo_ram : std_logic_vector(8 downto 0);
    
    --Classification 
    signal classification_in : std_logic_vector(7 downto 0);
    signal classification_out : std_logic_vector(7 downto 0);
    
    --Classification RAM
    signal wr_classifier_ram : std_logic;
    signal rd_classifier_ram : std_logic;
    signal addr_classifier_ram : std_logic_vector(8 downto 0);
    signal classifier_ram_out : std_logic_vector(7 downto 0);
    
    --Control Signals
    signal initialTransmission : std_logic := '0';
      
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
        din: in std_logic_vector(8-1 downto 0);
        dout: out std_logic_vector(8-1 downto 0);
        flag: out std_logic
    ); 
    end component;     
    
    component interface_fifo port(
        clk, reset: in std_logic;
        w_data: in std_logic_vector(8-1 downto 0);
        wr: in std_logic;
        rd: in std_logic;
        r_data: out std_logic_vector(8-1 downto 0);
        fifo_full: out std_logic;
        fifo_empty: out std_logic;
        num_elem: out std_logic_vector(1 downto 0)
    );  
    end component;
    
    component ram port(
        clk : in std_logic;
        wr : in std_logic;
        rd : in std_logic;
        addr : in std_logic_vector(9-1 downto 0);
        di : in std_logic_vector(8-1 downto 0);
        do : out std_logic_vector(8-1 downto 0)
    );
    end component;
    
    component classifier port(
        clk, reset: in std_logic;
        din: in std_logic_vector(8-1 downto 0);
        dout: out std_logic_vector(8-1 downto 0)
    );
    end component;
    
begin

u0: baud_gen port map(
    clk => clk,
    reset => reset,
    max_tick => max_tick,
    q => q
);

u_tx_interface_fifo : interface_fifo port map(
    clk => clk,
    reset => reset,
    wr => wr_tx_fifo,
    rd => wr_uart,
    w_data => w_data,
    r_data => din,
    num_elem => tx_fifo_num
);

u_tx: uart_tx port map(
    clk => clk,
    tx_start => tx_start,
    reset => reset,
    s_tick => max_tick,
    din => din,
    tx_done_tick => tx_done,
    tx => tx
);

u_rx_interface_fifo : interface_fifo port map(
    clk => clk,
    reset => reset,
    wr => rx_done_tick,
    rd => rd_uart,
    w_data => dout_rx,
    r_data => r_data,
    fifo_empty => rx_empty,
    num_elem => rx_fifo_num
);

u_rx : uart_rx port map(
    clk => clk,
    reset => reset,
    rx => tx,
    s_tick => max_tick,
    rx_done_tick => rx_done_tick,
    dout => dout_rx    
);

u_fifo_ram : ram port map(
    clk => clk,
    wr => wr_fifo_ram,
    rd => rd_fifo_ram,
    addr => addr_fifo_ram,
    di => r_data,
    do => classification_in
);

u_classifier : classifier port map(
    clk => clk,
    reset => reset,
    din => classification_in,
    dout => classification_out
);

u_classifier_ram : ram port map(
    clk => clk,
    wr => wr_classifier_ram,
    rd => rd_classifier_ram,
    addr => addr_classifier_ram,
    di => classification_out,
    do => classifier_ram_out
);

reset <= '0';
clk <= not clk after 10ns;

--process 

--variable fifo_addr : std_logic_vector(8 downto 0) := "000000000";

--begin

--wait for 30ns;

--if(initialTransmission = '0') then
--    ----------LOAD WRITE DATA INTO TX FIFO----------------------
--    w_data <= x"FF";
    
--    wait for 20ns;
    
--    wr_tx_fifo <= '1';
--    wait for 20ns;
--    wr_tx_fifo <= '0';
--    ---------------------------------------------------------
    
--    ----------WRITE UART----------------------------------    
--    wr_uart <= '1';
--    wait until tx_done = '1';
--    wr_uart <= '0';
    
--    wait for 0.5ms;
--    ------------------------------------------------------
    
--    ---------READ UART, STORING INTO RX FIFO---------------    
--    rd_uart <= '1';
--    wait for 500ns;
--    rd_uart  <= '0';
    
--    wait for 0.5ms;
--    --------------------------------------------------------
    
--    -----------WRITE DATA INTO FIFO RAM--------------------    
--    addr_fifo_ram  <= fifo_addr;
    
--    wr_fifo_ram <= '1';
--    wait for 500ns;
--    wr_fifo_ram  <= '0';
    
--    wait for 0.5ms;
--    ----------------------------------------------------------    
        
--    -------------READ DATA FROM FIFO RAM, SENDING TO CLASSIFIER----- 
--    rd_fifo_ram <= '1';
--    wait for 500ns;
--    rd_fifo_ram <= '0';
    
--    --Increment address
    
--    wait for 0.5ms;
--    ------------------------------------------------------------  
    
--    ------------WRITE CLASSIFIER TO RAM----------------------
--    addr_classifier_ram  <= fifo_addr;
    
--    wr_classifier_ram <= '1';
--    wait for 500ns;
--    wr_classifier_ram  <= '0';
    
--    wait for 0.5ms;
--    ---------------------------------------------------------  
    
--    ------------READ CLASSIFIER RAM, WRITEBACK TO TX----------------------
--    addr_classifier_ram  <= fifo_addr;
    
--    rd_classifier_ram <= '1';
--    wait for 500ns;
--    rd_classifier_ram  <= '0';
    
--    wait for 0.5ms;
--    w_data <= classifier_ram_out;
--    ---------------------------------------------------------  
    
--    initialTransmission <= '1';
--end if;

--if(initialTransmission = '1') then 
--    wait for 0.5ms;

--    ----------LOAD WRITE DATA INTO TX FIFO----------------------
--    wr_tx_fifo <= '1';
--    wait for 20ns;
--    wr_tx_fifo <= '0';
--    ---------------------------------------------------------
    
--    ----------WRITE UART----------------------------------    
--    wr_uart <= '1';
--    wait until tx_done = '1';
--    wr_uart <= '0';
    
--    wait for 0.5ms;
--    ------------------------------------------------------
    
--    ---------READ UART, STORING INTO RX FIFO---------------    
--    rd_uart <= '1';
--    wait for 500ns;
--    rd_uart  <= '0';
    
--    wait for 0.5ms;
--    --------------------------------------------------------
    
--    -----------WRITE DATA INTO FIFO RAM--------------------
--    fifo_addr := std_logic_vector(unsigned(fifo_addr) + 1);    
--    addr_fifo_ram  <= fifo_addr;
    
--    wr_fifo_ram <= '1';
--    wait for 500ns;
--    wr_fifo_ram  <= '0';
    
--    wait for 0.5ms;
--    ----------------------------------------------------------    
        
--    -------------READ DATA FROM FIFO RAM, SENDING TO CLASSIFIER----- 
--    rd_fifo_ram <= '1';
--    wait for 500ns;
--    rd_fifo_ram <= '0';
    
--    wait for 0.5ms;
--    ------------------------------------------------------------  
    
--    ------------WRITE CLASSIFIER TO RAM----------------------
--    addr_classifier_ram  <= fifo_addr;
    
--    wr_classifier_ram <= '1';
--    wait for 500ns;
--    wr_classifier_ram  <= '0';
    
--    wait for 0.5ms;
--    ---------------------------------------------------------  
    
--    ------------READ CLASSIFIER RAM, WRITEBACK TO TX----------------------
--    addr_classifier_ram  <= fifo_addr;
    
--    rd_classifier_ram <= '1';
--    wait for 500ns;
--    rd_classifier_ram  <= '0';
    
--    wait for 0.5ms;
--    w_data <= classifier_ram_out;
--    ---------------------------------------------------------  

--end if;

--end process;

process begin

wait for 10ns;

w_data <= "11111111";

wr_tx_fifo <= '1';
wait for 20ns;
wr_tx_fifo <= '0';

wait for 10ms;

end process;

--TX_FIFO-TX
process(tx_fifo_num)
begin

    if(tx_fifo_num = "11") then
        wr_uart <= '1';
    else 
        wr_uart <= '0';
    end if;

end process;

--FIFO-RAM1
process(rx_fifo_num)
begin

    if(rx_fifo_num = "11") then
        rd_uart <= '1';
    else 
        rd_uart <= '0';
    end if;

end process;

--RAM1-Classification-RAM2

--RAM2-FIFO_TX

end Behavioral;
