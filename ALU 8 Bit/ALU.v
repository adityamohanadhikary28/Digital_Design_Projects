`timescale 1ns / 1ps

`define add         4'b0000
`define sub         4'b0001
`define mul         4'b0010
`define div         4'b0011
`define reg_not     4'b0100
`define reg_or      4'b0101
`define reg_and     4'b0110
`define reg_xor     4'b0111
`define reg_xnor    4'b1000
`define reg_nor     4'b1001
`define reg_nand    4'b1010
`define shift_left  4'b1011
`define shift_right 4'b1100
`define reg_comp    4'b1101

module alu(input clk, [7:0] a, b, [2:0] shift_mag, [3:0] oper_type, output reg [15:0] dout);

parameter idle = 2'b00, check = 2'b01, compute = 2'b10;

reg [1:0] div_state = idle;
reg [7:0] temp, count;
reg [15:0] mul_res;
integer i;

always@(posedge clk) begin

case(oper_type)

`add: begin
dout <= a + b;
end

`sub: begin
dout <= a - b;
end

`mul: begin
mul_res = 16'b0;
for(i = 0; i < 8; i = i + 1) begin
if(b[i]) mul_res = mul_res + ({8'b0, a}<<i);
end
dout <= mul_res;
end

`div: begin
case(div_state)

idle: begin
temp <= a;
div_state <= check;
count <= 8'b0;
end

check: begin
if(temp >= b) begin
temp <= temp - b;
count <= count + 1;
div_state <= check;
end
else div_state <= compute;
end

compute: begin
dout <= {8'b0, count};
div_state <= idle;
end

default: begin
div_state <= idle;
end

endcase
end

`reg_not: begin
dout <= ~a;
end

`reg_or: begin
dout <= a|b;
end

`reg_and: begin
dout <= a*b;
end

`reg_xor: begin
dout <= a^b;
end
`reg_xnor: begin
dout <= ~(a^b);
end

`reg_nor: begin
dout <= ~(a|b);
end

`reg_nand: begin
dout <= ~(a*b);
end

`reg_comp: begin
if(a >= b) dout <= 16'b1;
else dout <= 16'b0;
end

`shift_left: begin
dout <= a << shift_mag;
end

`shift_right: begin
dout <= a >> shift_mag;
end

endcase

end
endmodule