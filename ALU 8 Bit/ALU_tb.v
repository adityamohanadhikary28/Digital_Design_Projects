module alu_tb;

reg clk; reg [7:0] a, b; reg [2:0] shift_mag; reg [3:0] oper_type; wire [15:0] dout;

alu uut(.clk(clk), .a(a), .b(b), .shift_mag(shift_mag), .oper_type(oper_type), .dout(dout));

initial clk = 0;

always #10 clk = ~clk;

initial begin

a = 0;
b = 0;
shift_mag = 0;
oper_type = 0;

$monitor($time, "a = %b, b = %b, oper_type = %b, dout = %b", a, b, oper_type, dout);

#20;

a = 8'b00011001; b = 8'b00001111; oper_type = `add;
#20;

a = 8'b00100011; b = 8'b00001111; oper_type = `sub;
#20;

a = 8'b11111111; b = 8'b11111111; oper_type = `mul;
#20;

a = 8'b00110010; b = 8'b00000111; oper_type = `div;
#300;

a = 8'b00100000; b = 8'b00001011; oper_type = `mul;
#30;

$finish;

end
endmodule