`timescale 1ns / 1ps
module i2c(input start, clk, ack, [6:0] addr, [7:0] din, output reg sda, scl);

integer bit_count  = 0, addr_count = 0, scl_count = 0;
reg scl_flag = 1'b0;

parameter idle = 3'b000, addr_out = 3'b001, addr_ack = 3'b010, serial_out = 3'b011, data_ack = 3'b100, tx_done = 3'b101, tx_failure = 3'b110;
reg [2:0] i2c_state = idle;
//scl synchronization
always@(posedge clk) begin: scl_sync

if(i2c_state == addr_out || i2c_state == serial_out || i2c_state == addr_ack || i2c_state == data_ack) begin
if(scl_count == 499) begin
scl_count <= 0;
scl_flag <= 1'b1;
scl <= ~scl;
end
else begin
scl_count <= scl_count + 1;
scl_flag <= 1'b0;
if(scl_count == 249) scl <= ~scl;
end
end

else begin
scl <= 1'b1;
scl_count <= 0;
scl_flag <= 1'b0;
end

end
//
//serial transmission
always@(posedge clk) begin: serial_tx

case(i2c_state) 

idle: begin
sda <= 1'b1;
if(start == 1'b0) begin
i2c_state <= idle;
end
else i2c_state <= addr_out;
end

addr_out: begin
if(scl_flag == 1'b1) begin
if(addr_count == 7) begin
sda <= 1'b0; // write bit
addr_count <= 0;
i2c_state <= addr_ack;
end
else begin
sda <= addr[6 - addr_count];
addr_count <= addr_count + 1;
i2c_state <= addr_out;
end
end
end

addr_ack: begin
sda <= 1'bz;
if(scl_flag == 1'b1) begin
if(ack == 1'b0) i2c_state <= serial_out;
else i2c_state <= tx_failure;
end
end

serial_out: begin
if(scl_flag == 1'b1) begin
if(bit_count == 8) begin
sda <= 1'b0; 
bit_count <= 0;
i2c_state <= data_ack;
end
else begin
sda <= din[7 - bit_count];
bit_count <= bit_count + 1;
i2c_state <= serial_out;
end
end
end

data_ack: begin
sda <= 1'bz;
if(scl_flag == 1'b1) begin
if(ack == 1'b0) i2c_state <= tx_done;
else i2c_state <= tx_failure;
end
end

tx_done: begin
sda <= 1'b0;
i2c_state <= idle;
end

tx_failure: begin
sda <= 1'b1;
i2c_state <= idle;
end

default: begin
i2c_state <= idle;
bit_count <= 0;
addr_count <= 0;
end

endcase
end
//
endmodule