 - A = FFH

   `-` A + 01H => A = 00H, zero = 1,   sign = 1, parity = 1, carry = 1, auxiliary carry = 1 

- A = 7FH

    `-` A + 01H => A = 80H, zero = 0, sign = 1, parity = 0, carry = 0, auxiliary carry = 1

- A = 03H

     `-` A | A => A = 03H, zero = 0, sign = 0, parity = 1, carry = 0, auxiliary carry = 0

- A = 0FH

     `-` A + 01H => A = 10H, zero = 0, sign = 0, parity = 0, carry = 0, auxiliary carry = 1