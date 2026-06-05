module cpu_8085_tb;

reg clk; reg rst; reg load; reg [7:0] din; wire [7:0] dout;

integer i;

cpu_8085 uut(.clk(clk), .rst(rst), .load(load), .din(din), .dout(dout));

initial begin
clk = 0;
forever #10 clk = ~clk;
end

initial begin
#10;
rst = 0; load = 1;
din = 8'h21; 
@(posedge clk);
din = 8'h00;
@(posedge clk);
din = 8'h24; 
@(posedge clk);
din = 8'h06; 
@(posedge clk);
din = 8'h0A; 
@(posedge clk);
din = 8'h0E; 
@(posedge clk);
din = 8'h02; 
@(posedge clk);
din = 8'h71; 
@(posedge clk);
din = 8'h0C; 
@(posedge clk);
din = 8'h23; 
@(posedge clk);
din = 8'h05; 
@(posedge clk);
din = 8'hC2; 
@(posedge clk);
din = 8'h07; 
@(posedge clk);
din = 8'h20; 
@(posedge clk);
din = 8'h21; 
@(posedge clk);
din = 8'h00; 
@(posedge clk);
din = 8'h24; 
@(posedge clk);
din = 8'h01; 
@(posedge clk);
din = 8'h00; 
@(posedge clk);
din = 8'h25; 
@(posedge clk);
din = 8'h16; 
@(posedge clk);
din = 8'h0A; 
@(posedge clk);
din = 8'h7E; 
@(posedge clk);
din = 8'h02; 
@(posedge clk);
din = 8'h23; 
@(posedge clk);
din = 8'h03; 
@(posedge clk);
din = 8'h15; 
@(posedge clk);
din = 8'hC2; 
@(posedge clk);
din = 8'h16; 
@(posedge clk);
din = 8'h20; 
@(posedge clk);
din = 8'h76;
load = 0;
rst = 1;
@(posedge clk);
$display("Final dout = %h", dout);
#5000;
$display("\nMemory Contents:");
for(i = 16'h2500; i <= 16'h2509; i = i + 1)
begin
$display("mem[%h] = %h", i, uut.mem[i]);
end
$finish;
end

endmodule