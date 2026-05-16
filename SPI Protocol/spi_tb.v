module spi_tb;

reg clk; reg start; reg [7:0] din; wire cs; wire sclk; wire mosi;

spi uut(.clk(clk), .start(start), .din(din), .cs(cs), .sclk(sclk), .mosi(mosi));

always #10 clk = ~clk;

initial begin

clk = 0;
start = 0;
din = 8'b10110011;

#50;

start = 1;

#20;

start = 0;

#20000;

din = 8'b11001100;

#50;

start = 1;

#20;

start = 0;

#20000;

$finish;

end

always @(posedge uut.sclk_flag) begin
$display("TIME = %0t | DIN = %b | MOSI = %b", $time, din, mosi);
end

endmodule