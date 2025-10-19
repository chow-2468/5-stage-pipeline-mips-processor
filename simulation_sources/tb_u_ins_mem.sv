`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: Ng Jing Xuan
//  
// Create Date: 08.09.2025 23:18:48
// File Name: tb_u_ins_mem.sv 
// Module Name: tb_u_ins_mem
// Project Name: MIPS ISA Pipeline processor
// Code Type: Behavioural 
// Description: Testbench for Instruction Memory Unit
//  
//////////////////////////////////////////////////////////////////////////////////
module tb_i_u_ins_mem();
parameter CC = 10;
logic tb_i_sys_clock;
logic [31:0] tb_i_u_ins_mem_ins_addr;
logic [31:0] tb_o_u_ins_mem_ins;
logic [31:0] tb_i_u_ins_mem_wr_ins;
logic tb_i_u_ins_mem_wr_en;

u_ins_mem dut_u_ins_mem
(.i_sys_clock(tb_i_sys_clock),
.i_u_ins_mem_ins_addr(tb_i_u_ins_mem_ins_addr),
.i_u_ins_mem_wr_ins(tb_i_u_ins_mem_wr_ins),
.i_u_ins_mem_wr_en(tb_i_u_ins_mem_wr_en),
.o_u_ins_mem_ins(tb_o_u_ins_mem_ins));


initial begin
tb_i_sys_clock = 1'b1;
forever #(CC/2) tb_i_sys_clock = ~tb_i_sys_clock ;
end


initial begin
tb_i_u_ins_mem_wr_en = 1'b0;  //read ins[0]
tb_i_u_ins_mem_ins_addr = 32'h00400000;
tb_i_u_ins_mem_wr_ins = 32'h0;

repeat (1) @(posedge tb_i_sys_clock);
tb_i_u_ins_mem_wr_en = 1'b1;  //write ins[0]
tb_i_u_ins_mem_ins_addr = 32'h00400000;
tb_i_u_ins_mem_wr_ins = 32'h20097fff;

repeat (1) @(posedge tb_i_sys_clock);
tb_i_u_ins_mem_wr_en = 1'b0;  //read ins[0] again
tb_i_u_ins_mem_ins_addr = 32'h00400000;
tb_i_u_ins_mem_wr_ins = 32'h00004444;  //ins will not write if wr_en is 0

repeat (1) @(posedge tb_i_sys_clock);
tb_i_u_ins_mem_wr_en = 1'b0;  //read ins[1]
tb_i_u_ins_mem_ins_addr = 32'h00400004;
tb_i_u_ins_mem_wr_ins = 32'h0;
end
endmodule
