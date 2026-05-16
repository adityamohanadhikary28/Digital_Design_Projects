`timescale 1ns / 1ps

module i2c_tb;

reg clk; reg start; reg ack; reg [6:0] addr; reg [7:0] din; wire sda; wire scl;

i2c dut(.clk(clk), .start(start), .ack(ack), .addr(addr), .din(din), .sda(sda), .scl(scl));

initial clk = 0;
always #10 clk = ~clk;

initial begin
start = 0;
ack = 0;
addr = 7'b1010010;
din = 8'b11001010;

#100;
start = 1;

#20;
start = 0;

#200000;
ack = 0;

#200000;
ack = 0;

#500000;

start = 0;

#100000;

$finish;
end

initial begin
$monitor("TIME = %0t | SDA = %b | ACK = %b | ADDR = %b | DIN = %b",$time, sda, ack, addr, din);
end

endmodule