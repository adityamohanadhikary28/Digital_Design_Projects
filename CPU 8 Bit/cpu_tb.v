`timescale 1ns / 1ps
module cpu_tb();

reg clk, sys_rst;
reg [15:0] din;
wire [15:0] dout;

cpu_8_bit DUT (.clk(clk), .sys_rst(sys_rst), .din(din), .dout(dout));

initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin
$display("----- CPU TESTBENCH STARTED -----");
sys_rst = 1;
din = 16'h0000;
#20;

sys_rst = 0;

din = 16'hAAAA;
#200;

din = 16'h5555;
#200;

#2000;

$display("----- CPU TESTBENCH FINISHED -----");
$stop;
end

always @(posedge clk) begin
$display("Time=%0t PC=%0d IR=%h dout=%h", $time, DUT.PC, DUT.IR, dout);
end

integer i;
always @(posedge clk) begin
$display("------ GPR Register Dump ------");
for(i = 0; i < 8; i = i + 1) begin
$display("GPR[%0d] = %h", i, DUT.GPR[i]);
end
end

endmodule