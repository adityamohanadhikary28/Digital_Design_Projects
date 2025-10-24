library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx_rx is
Port(start, clk: in std_logic;
     din : in std_logic_vector(7 downto 0);
     tx: out std_logic);
end uart_tx_rx;

architecture Behavioral of uart_tx_rx is

--10 MHz/9600 bps = 10416
signal count : integer range 0 to 10417 := 0;
signal baud_flag : std_logic := '0';

type state_type is (ready, data, flag);
signal state : state_type := ready;

signal tx_data : std_logic_vector(9 downto 0);
signal tx_temp : std_logic;
signal bit_count : integer range 0 to 9 := 0;

begin

baud_rate: process(clk)
begin
if(rising_edge(clk)) then
if(state = ready) then
count <= 0;
elsif(count < 10416) then
count <= count + 1;
baud_flag <= '0';
else 
baud_flag <= '1'; --10416 clock cycles have been completed.
count <= 0;
end if;
end if;
end process;

data_transmission: process(clk)
begin
if(rising_edge(clk)) then
case state is

when ready =>
if(start = '0') then
state <= ready;
else 
state <= data;
tx_data <= '1' & din & '0';
end if;

when data =>
tx_temp <= tx_data(bit_count);
bit_count <= bit_count + 1;
state <= flag;

when flag =>
if(baud_flag  = '1') then
if(bit_count < 10) then
state <= data;
else 
state <= ready;
end if;
else state <= flag;
end if;

when others => state <= ready;

end case;
end if;
end process;

tx <= tx_temp;

end Behavioral;