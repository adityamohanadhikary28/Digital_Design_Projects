`timescale 1ns / 1ps
module spi(input clk, start, input [7:0] din, output reg mosi, reg sclk, reg cs);

reg sclk_flag = 1'b0;
integer sclk_count = 0, bit_count = 0;

parameter idle = 2'b00, serial_out = 2'b01, tx_done = 2'b10;
reg [1:0] spi_state;

//clock synchronization
always @(posedge clk) begin: clk_sync

if(spi_state == serial_out) begin
if(sclk_count == 49) begin
sclk_count <= 0;
sclk_flag <= 1'b1;
end
else begin
sclk_count <= sclk_count + 1;
sclk_flag <= 1'b0;
end
if(sclk_count == 24 || sclk_count == 49) sclk <= ~sclk;
end

else begin
sclk <= 1'b0;      
sclk_count <= 0;
sclk_flag <= 0;
end

end
//
//data transmission
always@(posedge clk) begin: serial_transmission

case(spi_state)

idle: begin
if(start == 1'b0) begin
cs <= 1'b1; 
spi_state <= idle;
end
else spi_state <= serial_out;
end

serial_out: begin
cs <= 1'b0;
if(sclk_flag == 1'b1) begin
mosi <= din[7 - bit_count];
if(bit_count == 7) begin
bit_count <= 0;
spi_state <= tx_done;
end
else begin
bit_count <= bit_count + 1;
spi_state <= serial_out;
end
end
end

tx_done: begin
cs <= 1'b1;
bit_count <= 0;
spi_state <= idle;
end

default: begin
cs <= 1'b1;
spi_state <= idle;
end

endcase
end
//
endmodule