module cpu_8085_tb;

reg clk; reg rst; reg load; reg [7:0] din; wire [7:0] dout;

integer i;

cpu_8085 uut(.clk(clk), .rst(rst), .load(load), .din(din), .dout(dout));

initial begin
clk = 0;
forever #10 clk = ~clk;
end

always @(posedge clk)
begin
    $display("Time=%0t A=%h Zero=%b S=%b P=%b CY=%b AC=%b",
             $time, uut.A, uut.zero, uut.sign, uut.parity, uut.carry, uut.aux);
end

initial begin
#10;
rst = 0; load = 1;
din = 8'h3E; 
@(posedge clk);
din = 8'hFF;
@(posedge clk);
din = 8'hC6; 
@(posedge clk);
din = 8'h01; 
@(posedge clk);
din = 8'h3E; 
@(posedge clk);
din = 8'h7F; 
@(posedge clk);
din = 8'hC6; 
@(posedge clk);
din = 8'h01; 
@(posedge clk);
din = 8'h3E; 
@(posedge clk);
din = 8'h03; 
@(posedge clk);
din = 8'hB7; 
@(posedge clk);
din = 8'h3E; 
@(posedge clk);
din = 8'h0F; 
@(posedge clk);
din = 8'hC6; 
@(posedge clk);
din = 8'h01; 
@(posedge clk);
din = 8'h76; 
load = 0;
rst = 1;
@(posedge clk);
$display("Final dout = %h", dout);
#5000;
$finish;
end

endmodule