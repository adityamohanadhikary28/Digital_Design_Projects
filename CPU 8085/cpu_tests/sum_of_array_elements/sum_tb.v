module cpu_8085_tb;

reg clk; reg rst; reg load; reg [7:0] din; wire [7:0] dout;

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
din = 8'h36; 
@(posedge clk);
din = 8'h24; 
@(posedge clk);
din = 8'h23; 
@(posedge clk);
din = 8'h36; 
@(posedge clk);
din = 8'h21; 
@(posedge clk);
din = 8'h23; 
@(posedge clk);
din = 8'h36; 
@(posedge clk);
din = 8'h14; 
@(posedge clk);
din = 8'h23; 
@(posedge clk);
din = 8'h36; 
@(posedge clk);
din = 8'h08; 
@(posedge clk);
din = 8'h23; 
@(posedge clk);
din = 8'h36; 
@(posedge clk);
din = 8'h07; 
@(posedge clk);
din = 8'h3E; 
@(posedge clk);
din = 8'h00; 
@(posedge clk);
din = 8'h0E; 
@(posedge clk);
din = 8'h05; 
@(posedge clk);
din = 8'h21; 
@(posedge clk);
din = 8'h00; 
@(posedge clk);
din = 8'h24; 
@(posedge clk);
din = 8'h86; 
@(posedge clk);
din = 8'h0D; 
@(posedge clk);
din = 8'h23; 
@(posedge clk);
din = 8'hC2; 
@(posedge clk);
din = 8'h18; 
@(posedge clk);
din = 8'h20; 
@(posedge clk);
din = 8'h76; 
@(posedge clk);
load = 0;
rst = 1;
@(posedge clk);
$display("Final dout = %h", dout);
#2000;
$finish;
end

endmodule