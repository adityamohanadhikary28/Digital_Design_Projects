library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_8_bit is
    Port (
        in_sel : in  std_logic;
        a, b : in  std_logic_vector(7 downto 0);
        a_frac, b_frac : in std_logic_vector(3 downto 0);
        sel : in  std_logic_vector(3 downto 0);
        y : out std_logic_vector(8 downto 0);
        y_mul : out std_logic_vector(15 downto 0);
        y_frac : out std_logic_vector(4 downto 0)
    );
end alu_8_bit;

architecture Behavioral of alu_8_bit is

    function ripple_carry_adder(
        A : std_logic_vector;
        B : std_logic_vector;
        Cin : std_logic
    ) return std_logic_vector is
        variable Sum   : std_logic_vector(A'range);
        variable Carry : std_logic := Cin;
        variable Cout  : std_logic := '0';
    begin
        for i in 0 to A'length-1 loop
            Sum(i) := A(i) xor B(i) xor Carry;
            Carry := (A(i) and B(i)) or (A(i) and Carry) or (B(i) and Carry);
            if i = A'length-1 then
                Cout := Carry;
            end if;
        end loop;
        return Cout & Sum;
    end function;

    function subtractor(
        A : std_logic_vector;
        B : std_logic_vector;
        Bin : std_logic
    ) return std_logic_vector is
        variable Sub : std_logic_vector(A'range);
        variable Borrow : std_logic := Bin;
        variable Bout : std_logic := '0';
    begin
        for i in 0 to A'length-1 loop
            Sub(i) := A(i) xor B(i) xor Borrow;
            Borrow := ((not A(i)) and (B(i) or Borrow)) or (B(i) and Borrow);
            if i = A'length-1 then
                Bout := Borrow;
            end if;
        end loop;
        return Bout & Sub;
    end function;

begin

    process(a, b, a_frac, b_frac, sel, in_sel)
        variable temp_y : std_logic_vector(8 downto 0) := (others => '0');
        variable temp_yfrac : std_logic_vector(4 downto 0) := (others => '0');
        variable t_ymul : std_logic_vector(15 downto 0) := (others => '0');
        variable a_temp, b_temp : integer := 0;
    begin
        a_temp := to_integer(unsigned(a));
        b_temp := to_integer(unsigned(b));

        temp_y := (others => '0');
        temp_yfrac := (others => '0');
        t_ymul := (others => '0');

        case sel is
            when "0000" =>
                temp_yfrac := ripple_carry_adder(a_frac, b_frac, '0');
                temp_y := ripple_carry_adder(a, b, temp_yfrac(4));

            when "0001" =>
                temp_yfrac := subtractor(a_frac, b_frac, '0');
                temp_y := subtractor(a, b, temp_yfrac(4));

            when "0010" =>
                t_ymul := std_logic_vector(to_unsigned(a_temp * b_temp, 16));
                temp_yfrac := (others => '0');

            when "0011" =>
                if b_temp /= 0 then
                    temp_y := std_logic_vector(to_unsigned(a_temp / b_temp, 9));
                    temp_yfrac := std_logic_vector(to_unsigned(a_temp mod b_temp, 5));
                else
                    temp_y := (others => '0');
                    temp_yfrac := (others => '0');
                end if;

            when "0100" =>
                temp_y := '0' & (a or b);
                temp_yfrac := '0' & (a_frac or b_frac);

            when "0101" =>
                temp_y := '0' & (a and b);
                temp_yfrac := '0' & (a_frac and b_frac);

            when "0110" =>
                temp_y := '0' & (a xor b);
                temp_yfrac := '0' & (a_frac xor b_frac);

            when "0111" =>
                temp_y := '0' & (a xnor b);
                temp_yfrac := '0' & (a_frac xnor b_frac);

            when "1000" =>
                temp_y := '0' & not(a or b);
                temp_yfrac := '0' & not(a_frac or b_frac);

            when "1001" =>
                temp_y := '0' & not(a and b);
                temp_yfrac := '0' & not(a_frac and b_frac);

            when "1010" =>
                if in_sel = '1' then
                    temp_y := '0' & not b;
                    temp_yfrac := '0' & not b_frac;
                else
                    temp_y := '0' & not a;
                    temp_yfrac := '0' & not a_frac;
                end if;

            when "1011" =>
                if a_temp >= b_temp then
                    temp_y := "000000001";
                else
                    temp_y := (others => '0');
                end if;
                temp_yfrac := (others => '0');

            when others =>
                temp_y := (others => '0');
                temp_yfrac := (others => '0');
        end case;

        y <= temp_y;
        y_frac <= temp_yfrac;
        y_mul <= t_ymul;

    end process;

end Behavioral;