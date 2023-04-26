library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity interface_fifo is
    generic(W: integer := 8);
    Port (        
        clk, reset: in std_logic;
        w_data: in std_logic_vector(W-1 downto 0);
        wr: in std_logic;
        rd: in std_logic;
        r_data: out std_logic_vector(W-1 downto 0);
        fifo_full: out std_logic;
        fifo_empty: out std_logic
    );
end interface_fifo;

architecture Behavioral of interface_fifo is

type memory_type is array (0 to W-1) of std_logic_vector(7 downto 0);
signal memory : memory_type :=(others => (others => '0'));   --memory for queue.
signal readptr,writeptr : integer := 0;  --read and write pointers.
signal empty,full : std_logic := '0';

begin
    fifo_empty <= empty;
    fifo_full <= full;

    process(clk, reset) -- FSMD state and data regs.
    variable num_elem : integer := 0;
    begin
        if (reset = '1') then
            r_data <= (others => '0');
            empty <= '0';
            full <= '0';
            readptr <= 0;
            writeptr <= 0;
            num_elem := 0;
        elsif (clk'event and clk='1') then

            if(rd = '1' and empty = '0') then  --read
                r_data <= memory(readptr);
                readptr <= readptr + 1;      
                num_elem := num_elem-1;
            end if;
            if(wr ='1' and full = '0') then    --write
                memory(writeptr) <= w_data;
                writeptr <= writeptr + 1;  
                num_elem := num_elem+1;
            end if;
            --rolling over of the indices.
            if(readptr = W-1) then      --resetting read pointer.
                readptr <= 0;
            end if;
            if(writeptr = W-1) then        --resetting write pointer.
                writeptr <= 0;
            end if; 
            --setting empty and full flags.
            if(num_elem = 0) then
                empty <= '1';
            else
                empty <= '0';
            end if;
            if(num_elem = W) then
                full <= '1';
            else
                full <= '0';
            end if;
        end if;
    end process;

end Behavioral;