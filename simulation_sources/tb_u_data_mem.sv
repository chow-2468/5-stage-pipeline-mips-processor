`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: Ng Jing Xuan
//  
// Create Date: 08.09.2025 23:18:48
// File Name: tb_u_data_mem.sv 
// Module Name: tb_u_data_mem
// Project Name: MIPS ISA Pipeline processor
// Code Type: Behavioural 
// Description: Testbench for Data Memory Unit
//  
//////////////////////////////////////////////////////////////////////////////////
module tb_u_data_mem();
parameter CC = 10;
logic tb_i_sys_clock;
logic [31:0] tb_i_u_data_mem_data_addr;
logic [31:0] tb_i_u_data_mem_write_data;
logic tb_i_u_data_mem_mem_wr;
logic tb_i_u_data_mem_word;
logic [31:0] tb_o_u_data_mem_data;


u_data_mem dut_u_data_mem
(.i_sys_clock(tb_i_sys_clock),
.i_u_data_mem_data_addr(tb_i_u_data_mem_data_addr),
.i_u_data_mem_write_data(tb_i_u_data_mem_write_data),
.i_u_data_mem_mem_wr(tb_i_u_data_mem_mem_wr),
.i_u_data_mem_word(tb_i_u_data_mem_word),
.o_u_data_mem_data(tb_o_u_data_mem_data));


initial begin
tb_i_sys_clock = 1'b1;
forever #(CC/2) tb_i_sys_clock = ~tb_i_sys_clock ;
end


initial begin
tb_i_u_data_mem_mem_wr = 1'b0; //read word data [0] initially =0
tb_i_u_data_mem_word = 1'b1;
tb_i_u_data_mem_data_addr = 32'h10000000;
tb_i_u_data_mem_write_data = 32'h00000000;

repeat (1) @(posedge tb_i_sys_clock);
tb_i_u_data_mem_mem_wr = 1'b1; //write word data [0]
tb_i_u_data_mem_word = 1'b1;
tb_i_u_data_mem_data_addr = 32'h10000000;
tb_i_u_data_mem_write_data = 32'h87654321;

repeat (2) @(posedge tb_i_sys_clock);
tb_i_u_data_mem_mem_wr = 1'b0; //read word data [0]
tb_i_u_data_mem_word = 1'b1;
tb_i_u_data_mem_data_addr = 32'h10000000;
tb_i_u_data_mem_write_data = 32'h000000FF;

repeat (1) @(posedge tb_i_sys_clock);
tb_i_u_data_mem_mem_wr = 1'b0; //read data [0] byte 2
tb_i_u_data_mem_word = 1'b0;
tb_i_u_data_mem_data_addr = 32'h10000002;
tb_i_u_data_mem_write_data = 32'h0;


repeat (1) @(posedge tb_i_sys_clock);
tb_i_u_data_mem_mem_wr = 1'b1; //write data [1] byte 0
tb_i_u_data_mem_word = 1'b0;
tb_i_u_data_mem_data_addr = 32'h10000005;
tb_i_u_data_mem_write_data = 32'h000000FF;

repeat (2) @(posedge tb_i_sys_clock);
tb_i_u_data_mem_mem_wr = 1'b0;  //read data [1]
tb_i_u_data_mem_word = 1'b1;
tb_i_u_data_mem_data_addr = 32'h10000004;
tb_i_u_data_mem_write_data = 32'h0;
end
endmodule