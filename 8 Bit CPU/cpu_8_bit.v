`timescale 1ns / 1ps

`define oper_type IR[31:27]
`define reg_dest IR[26:22]
`define reg_src1 IR[21:17]
`define imm_mode IR[16]
`define reg_src2 IR[15:11]
`define imm_data IR[15:0]

`define movsgpr 5'b00000
`define mov 5'b00001
`define add 5'b00010
`define sub 5'b00011
`define mul 5'b00100
 
`define reg_or 5'b00101
`define reg_and 5'b00110
`define reg_xor 5'b00111
`define reg_xnor 5'b01000
`define reg_nand 5'b01001
`define reg_nor 5'b01010
`define reg_not 5'b01011
 
`define storereg 5'b01101   
`define storedin 5'b01110   
`define senddout 5'b01111   
`define sendreg 5'b10001 

`define jmp 5'b10010
`define jc 5'b10011
`define jnc 5'b10100
`define jsign 5'b10101
`define jnosign 5'b10110
`define jz 5'b10111
`define jnz 5'b11000
`define jovf 5'b11001
`define jnoovf 5'b11010  

`define halt 5'b11011
  
module cpu_8_bit(input clk, sys_rst, input [15:0] din, output reg [15:0] dout);

reg [31:0] prog_mem [15:0]; 
reg [15:0] data_mem [15:0];
 
reg [31:0] IR;            

reg [15:0] GPR [31:0] ; 

reg [15:0] SGPR ;

reg [31:0] mul_res;

reg sign = 0, zero = 0, ovf = 0, carry = 0;
reg [16:0] temp_sum;

reg jmp_flag = 0, stop = 0;

task decode_inst();
begin

jmp_flag = 1'b0;
stop = 1'b0;

case(`oper_type)

`movsgpr: begin
GPR[`reg_dest] = SGPR;   
end

`mov : begin
if(`imm_mode) GPR[`reg_dest] = `imm_data;
else GPR[`reg_dest] = GPR[`reg_src1];
end
 
`add : begin
if(`imm_mode) GPR[`reg_dest] = GPR[`reg_src1] + `imm_data;
else GPR[`reg_dest] = GPR[`reg_src1] + GPR[`reg_src2];
end
 
`sub : begin
if(`imm_mode) GPR[`reg_dest] = GPR[`reg_src1] - `imm_data;
else GPR[`reg_dest] = GPR[`reg_src1] - GPR[`reg_src2];
end
 
`mul : begin
if(`imm_mode) mul_res = GPR[`reg_src1] * `imm_data;
else mul_res = GPR[`reg_src1] * GPR[`reg_src2];
        
GPR[`reg_dest] =  mul_res[15:0];
SGPR = mul_res[31:16];
end
 
`reg_or : begin
if(`imm_mode) GPR[`reg_dest] = GPR[`reg_src1] | `imm_data;
else GPR[`reg_dest] = GPR[`reg_src1] | GPR[`reg_src2];
end
 
`reg_and : begin
if(`imm_mode) GPR[`reg_dest] = GPR[`reg_src1] & `imm_data;
else GPR[`reg_dest] = GPR[`reg_src1] & GPR[`reg_src2];
end

`reg_xor : begin
if(`imm_mode) GPR[`reg_dest] = GPR[`reg_src1] ^ `imm_data;
else GPR[`reg_dest] = GPR[`reg_src1] ^ GPR[`reg_src2];
end
 
`reg_xnor : begin
if(`imm_mode) GPR[`reg_dest] = GPR[`reg_src1] ~^ `imm_data;
else GPR[`reg_dest] = GPR[`reg_src1] ~^ GPR[`reg_src2];
end
 
`reg_nand : begin
if(`imm_mode) GPR[`reg_dest] = ~(GPR[`reg_src1] & `imm_data);
else GPR[`reg_dest] = ~(GPR[`reg_src1] & GPR[`reg_src2]);
end
 
`reg_nor : begin
if(`imm_mode) GPR[`reg_dest] = ~(GPR[`reg_src1] | `imm_data);
else GPR[`reg_dest] = ~(GPR[`reg_src1] | GPR[`reg_src2]);
end
 
`reg_not : begin
if(`imm_mode) GPR[`reg_dest] = ~(`imm_data);
else GPR[`reg_dest] = ~(GPR[`reg_src1]);
end

`storedin: begin
data_mem[`imm_data] = din;
end
 
`storereg: begin
data_mem[`imm_data] = GPR[`reg_src1];
end
 
`senddout: begin
dout = data_mem[`imm_data]; 
end
 
`sendreg: begin
GPR[`reg_dest] = data_mem[`imm_data];
end

`jmp: begin
jmp_flag = 1'b1;
end

`jc: begin
if(carry == 1'b1) jmp_flag = 1'b1;
else jmp_flag = 1'b0; 
end

`jsign: begin
if(sign == 1'b1) jmp_flag = 1'b1;
else jmp_flag = 1'b0; 
end

`jz: begin
if(zero == 1'b1) jmp_flag = 1'b1;
else jmp_flag = 1'b0; 
end

`jovf: begin
if(ovf == 1'b1) jmp_flag = 1'b1;
else jmp_flag = 1'b0; 
end

`jnc: begin
if(carry == 1'b0) jmp_flag = 1'b1;
else jmp_flag = 1'b0; 
end
 
`jnosign: begin
if(sign == 1'b0) jmp_flag = 1'b1;
else jmp_flag = 1'b0; 
end
 
`jnz: begin
if(zero == 1'b0) jmp_flag = 1'b1;
else jmp_flag = 1'b0; 
end

`jnoovf: begin
if(ovf == 1'b0) jmp_flag = 1'b1;
else jmp_flag = 1'b0; 
end

`halt : begin
stop = 1'b1;
end

endcase
end
endtask

task decode_condflag();
begin

if(`oper_type == `mul) sign = SGPR[15];
else sign = GPR[`reg_dest][15];
 
if(`oper_type == `add)
begin
if(`imm_mode)
begin
temp_sum = GPR[`reg_src1] + `imm_data;
carry = temp_sum[16]; 
end
else
begin
temp_sum = GPR[`reg_src1] + GPR[`reg_src2];
carry = temp_sum[16]; 
end 
end
else
begin
carry = 1'b0;
end

zero =  (~(|GPR[`reg_dest]) | ~(|SGPR[15:0])); 
 
if(`oper_type == `add)
begin
if(`imm_mode)
ovf = ((~GPR[`reg_src1][15] & ~IR[15] & GPR[`reg_dest][15]) | (GPR[`reg_src1][15] & IR[15] & ~GPR[`reg_dest][15]));
else
ovf = ((~GPR[`reg_src1][15] & ~GPR[`reg_src2][15] & GPR[`reg_dest][15]) | (GPR[`reg_src1][15] & GPR[`reg_src2][15] & ~GPR[`reg_dest][15]));
end
else if(`oper_type == `sub)
begin
if(`imm_mode)
ovf = ((~GPR[`reg_src1][15] & IR[15] & GPR[`reg_dest][15]) | (GPR[`reg_src1][15] & ~IR[15] & ~GPR[`reg_dest][15]));
else
ovf = ((~GPR[`reg_src1][15] & GPR[`reg_src2][15] & GPR[`reg_dest][15]) | (GPR[`reg_src1][15] & ~GPR[`reg_src2][15] & ~GPR[`reg_dest][15]));
end 
else
begin
ovf = 1'b0;
end
 
end
endtask
 
initial begin
$readmemb("C:/Users/adity/Desktop/data_inst.mem",prog_mem);
end

reg [2:0] count = 0;
integer PC = 0;
 
/* always@(posedge clk)
begin
if(sys_rst)
begin
count <= 0;
PC <= 0;
end
else 
begin
if(count < 4)
begin
count <= count + 1;
end
else
begin
count <= 0;
PC <= PC + 1;
end
end
end */

/* always@(*)
begin
if(sys_rst == 1'b1)
IR = 0;
else
begin
IR = prog_mem[PC];
decode_inst();
decode_condflag();
end
end */

parameter idle = 0, fetch = 1, dec_exec = 2, next_inst = 3, sense_halt = 4, delay = 5;

reg [2:0] state = idle, next_state = idle;

always@(posedge clk)
begin
if(sys_rst) state <= idle;
else state <= next_state; 
end

always@(*)
begin
case(state)

idle: begin
IR = 32'h0;
PC = 0;
next_state = fetch;
end
 
fetch: begin
IR =  prog_mem[PC];   
next_state  = dec_exec;
end
  
dec_exec: begin
decode_inst();
decode_condflag();
next_state  = delay;   
end

delay: begin
if(count < 4) next_state  = delay;       
else next_state = next_inst;
end
  
next_inst: begin
next_state = sense_halt;
if(jmp_flag == 1'b1) PC = `imm_data;
else PC = PC + 1;
end
    
sense_halt: begin
if(stop == 1'b0) next_state = fetch;
else if(sys_rst == 1'b1) next_state = idle;
else next_state = sense_halt;
end
  
default : next_state = idle;

endcase 
end

always@(posedge clk)
begin
case(state)
 
idle: begin
count <= 0;
end
 
fetch: begin
count <= 0;
end
 
dec_exec: begin
count <= 0;    
end  
 
delay: begin
count <= count + 1;
end
 
next_inst: begin
count <= 0;
end
 
sense_halt: begin
count <= 0;
end
 
default: count <= 0;
  
endcase
end
 
endmodule