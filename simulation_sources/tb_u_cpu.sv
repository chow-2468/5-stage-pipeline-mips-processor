`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: Ng Jing Xuan
//  
// Create Date: 08.09.2025 23:18:48
// File Name: tb_u_cpu.sv 
// Module Name: tb_u_cpu
// Project Name: MIPS ISA Pipeline processor
// Code Type: Behavioural 
// Description: Testbench for CPU Unit
//  
//////////////////////////////////////////////////////////////////////////////////
module tb_u_cpu();
parameter CC = 20;
logic tb_i_sys_clock;
logic tb_i_sys_reset;
logic [31:0] tb_i_u_cpu_data;
logic [31:0] tb_i_u_cpu_ins;
logic [31:0] tb_o_u_cpu_ins_addr;
logic [31:0] tb_o_u_cpu_data_addr;
logic [31:0] tb_o_u_cpu_write_data;
logic tb_o_u_cpu_word;
logic tb_o_u_cpu_mem_wr;


u_cpu dut_u_cpu
(.i_sys_clock(tb_i_sys_clock),
.i_sys_reset(tb_i_sys_reset),
.i_u_cpu_data(tb_i_u_cpu_data),
.i_u_cpu_ins(tb_i_u_cpu_ins),
.o_u_cpu_ins_addr(tb_o_u_cpu_ins_addr),
.o_u_cpu_data_addr(tb_o_u_cpu_data_addr),
.o_u_cpu_write_data(tb_o_u_cpu_write_data),
.o_u_cpu_word(tb_o_u_cpu_word),
.o_u_cpu_mem_wr(tb_o_u_cpu_mem_wr));


initial begin
tb_i_sys_clock = 1'b1;
forever #(CC/2) tb_i_sys_clock = ~tb_i_sys_clock ;
end

initial begin
tb_i_sys_reset = 1'b1;
repeat (1) @(posedge tb_i_sys_clock); 

tb_i_sys_reset = 1'b0;
tb_i_u_cpu_data = 32'h0;
tb_i_u_cpu_ins = 32'h340804D2;      //ori $t0, $zero, 1234
repeat (1) @(posedge tb_i_sys_clock);

tb_i_u_cpu_ins = 32'h0;
repeat (4) @(posedge tb_i_sys_clock); //nop x3

tb_i_u_cpu_ins = 32'h01004822;        //sub $t1, $t0, $zero
repeat (1) @(posedge tb_i_sys_clock); 

////////////////////////////////////////////////////////////////////////////////////
tb_i_u_cpu_ins = 32'h3C0F03E8;        //lui $t7, 1000
repeat (1) @(posedge tb_i_sys_clock); 

tb_i_u_cpu_ins = 32'h3C0A1234;        //lui $t2, 0x1234   
repeat (1) @(posedge tb_i_sys_clock); 

tb_i_u_cpu_ins = 32'h0;
repeat (3) @(posedge tb_i_sys_clock); //nop x3

tb_i_u_cpu_ins = 32'h214A1E61;        //addi $t2, $t2, 7777
repeat (1) @(posedge tb_i_sys_clock); 

tb_i_u_cpu_ins = 32'h200B003A;        //addi $t3, $zero, 58
repeat (1) @(posedge tb_i_sys_clock);

tb_i_u_cpu_ins = 32'h0; //nop x3
repeat (3) @(posedge tb_i_sys_clock); 

tb_i_u_cpu_ins = 32'hADEA0000;        //sw $t2, 0($t7)
repeat (1) @(posedge tb_i_sys_clock); 

tb_i_u_cpu_ins = 32'h0; //nop x3
repeat (4) @(posedge tb_i_sys_clock); 

tb_i_u_cpu_ins = 32'hA1EB0001;        //sb $t3, 1($t7)
end
endmodule
