`timescale 1ns / 1ps
module uart #(parameter clk_freq = 50000000, parameter baud_rate = 9600)
(input start, clk, [7:0] din, output reg dout);

reg baud_flag = 1'b0;
integer baud_count = 0, bit_count = 0;

localparam baud_div = clk_freq/baud_rate;

localparam idle = 2'b00, serial_out = 2'b01, tx_done = 2'b10;
reg [1:0] tx_state = idle;
reg [9:0] serial_data;

//Baud Counter
always@(posedge clk) begin: Baud_Rate

if(tx_state == serial_out) begin
if(baud_count < 5207) begin
baud_count <= baud_count + 1;
baud_flag <= 1'b0;
end
else begin
baud_count <= 0;
baud_flag <= 1'b1;
end
end

else begin
baud_count <= 0;
baud_flag <= 1'b0;
end

end
//
//Serial Transmission
always@(posedge clk) begin: serial_transmission

case(tx_state) 

idle: begin
if(start == 1'b0) begin 
tx_state <= idle;
dout <= 1'b1;
end
else begin 
tx_state <= serial_out;
serial_data <= {1'b1, din, 1'b0};
end
end

serial_out: begin
if(baud_flag == 1'b1) begin
if(bit_count <= 9) begin
dout <= serial_data[bit_count];
bit_count <= bit_count + 1;
tx_state <= serial_out;
end
else tx_state <= tx_done;
end
end

tx_done: begin
dout <= 1'b1;
bit_count <= 0;
tx_state <= idle;
end

default: begin 
tx_state <= idle;
bit_count <= 0;
end

endcase

end

endmodule