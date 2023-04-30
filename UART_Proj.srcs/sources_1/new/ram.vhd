LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity ram is
    generic ( 
        w : integer := 8; -- number of bits per RAM word
        r : integer := 9 -- number of words in RAM
    );
        port (clk : in std_logic;
        wr : in std_logic;
        rd : in std_logic;
        addr : in std_logic_vector(r-1 downto 0);
        di : in std_logic_vector(w-1 downto 0);
        do : out std_logic_vector(w-1 downto 0)
    );
end ram;

architecture behavioral of ram is
type ram_type is array (0 to 2**r-1) of std_logic_vector (w-1 downto 0);

signal RAM : ram_type := (others => (others => '0'));

begin

process (clk)
begin
    if rising_edge(clk) then
        if (rd = '1') then
            do <= RAM(to_integer(unsigned(addr)));
        end if;
        
        if (wr = '1') then
            RAM(to_integer(unsigned(addr))) <= di;
        end if;
    end if;
end process;

end behavioral;

--function to_str(a: std_logic_vector) return string is

--variable b : string (1 to a'length) := (others => NULL);
--variable stri : integer := 1; 

--begin
--    for i in a'range loop
--        b(stri) := std_logic'image(a((i)))(2);
--    stri := stri+1;
--    end loop;
--return b;
--end function;
