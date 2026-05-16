module uart_tb;

reg clk; reg start; reg [7:0] din; wire dout;

uart #(.clk_freq(50000000), .baud_rate(115200))
uut(.start(start), .clk(clk), .din(din), .dout(dout));

initial begin
clk = 0;
forever #10 clk = ~clk;
end

initial begin

start = 0;
din = 8'b10101010;

#100;

start = 1;

#20;

start = 0;

#1300000;

din = 8'b11001100;

#100;

start = 1;

#20;

start = 0;

#1100000;

$finish;

end

always@(posedge uut.baud_flag) begin
$display("TIME = %0t | DIN = %b | DOUT = %b",$time, din, dout);
end

endmodule