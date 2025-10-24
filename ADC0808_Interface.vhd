library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adc_interface is
    Port (
        clk, tr, eoc : in  std_logic;               
        ch    : in  std_logic_vector(2 downto 0);               
        din   : in  std_logic_vector(7 downto 0); 
        a, b, c, ale, sc, oe : out std_logic;            
        dout    : out std_logic_vector(7 downto 0));
end adc_interface;

architecture Behavioral of adc_interface is

    type state_type is (IDLE, LATCH_START, PULSE_LOW, WAIT_EOC, READ_DATA);
    signal state      : state_type := IDLE;
    signal temp_out   : std_logic_vector(7 downto 0) := (others => '0');

begin

process(clk)
begin
    if rising_edge(clk) then

        case state is

            when IDLE =>
                ale <= '0';
                sc  <= '0';
                oe  <= '0';
                if tr = '1' then
                    state <= LATCH_START;
                end if;

            when LATCH_START =>
                case ch is
                    when "000" => a <= '0'; b <= '0'; c <= '0';
                    when "001" => a <= '1'; b <= '0'; c <= '0';
                    when "010" => a <= '0'; b <= '1'; c <= '0';
                    when "011" => a <= '1'; b <= '1'; c <= '0';
                    when "100" => a <= '0'; b <= '0'; c <= '1';
                    when "101" => a <= '1'; b <= '0'; c <= '1';
                    when "110" => a <= '0'; b <= '1'; c <= '1';
                    when "111" => a <= '1'; b <= '1'; c <= '1';
                    when others => a <= '0'; b <= '0'; c <= '0';
                end case;
                ale <= '1';
                sc  <= '1';  
                state <= PULSE_LOW;

            when PULSE_LOW =>
                ale <= '0';
                sc  <= '0';  
                state <= WAIT_EOC;

            when WAIT_EOC =>
                if eoc = '0' then  
                    state <= READ_DATA;
                else state <= WAIT_EOC;
                end if;

            when READ_DATA =>
                oe <= '1';           
                temp_out <= din;     
                oe <= '0';           
                state <= IDLE;       

        end case;

    end if;
end process;

dout <= temp_out;

end Behavioral;