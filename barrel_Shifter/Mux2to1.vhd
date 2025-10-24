library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1 is
    Port ( I0, I1, sel : in STD_LOGIC;
           y : out STD_LOGIC);
end mux2to1;

architecture behavioral of mux2to1 is
begin
    y <= I0 when sel = '0' else
         I1 when sel = '1' else
         '0'; 
end behavioral;