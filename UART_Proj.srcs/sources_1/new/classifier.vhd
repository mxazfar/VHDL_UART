library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Classifier is
    generic(W: integer := 8);
    Port ( 
        clk, reset: in std_logic;
        din: in std_logic_vector(W-1 downto 0);
        dout: out std_logic_vector(W-1 downto 0)
    );
end Classifier;

architecture Behavioral of Classifier is

begin
    process(clk, reset)
    begin
        if (reset = '1') then
            dout <= x"00";
        elsif (clk'event and clk='1') then
            if (din <= x"FF" and din > x"E0") then
                dout <= x"01";
            elsif (din <= x"DF" and din > x"C0") then
                dout <= x"C1";
            elsif (din <= x"BF" and din > x"A0") then
                dout <= x"55";
            elsif (din <= x"9F" and din > x"80") then
                dout <= x"A1";
            elsif (din <= x"7F" and din > x"60") then
                dout <= x"81";
            elsif (din <= x"5F" and din > x"40") then
                dout <= x"61";
            elsif (din <= x"3F" and din > x"20") then
                dout <= x"41";
            elsif (din <= x"1F") then
                dout <= x"21";
            end if;
        end if;
    end process;

end Behavioral;