`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: Ng Yu Heng 
//  
// Create Date: 07.09.2025 13:45:34
// File Name: c_mips.sv
// Module Name: c_mips
// Project Name: MIPS ISA Pipeline processor
// Code Type: RTL level
// Description: Modeling of Mips pipeline processor chip block
//  
//////////////////////////////////////////////////////////////////////////////////

module c_mips(
    input logic i_c_sys_reset,
    input logic i_c_sys_clock,
    input logic [31:0] i_c_write_ins,
    input logic i_c_ins_wr
    );
    
    // Internal wires connecting CPU & instruction memory
    logic [31:0] cpu_ins_addr;
    logic [31:0] ins_mem_ins;
    
    
    // Internal wires connecting CPU &* data memory
    logic [31:0] cpu_data_addr;
    logic [31:0] cpu_write_data;
    logic        cpu_mem_wr;
    logic        cpu_word;
    logic [31:0] data_mem_data;
   
   
    u_cpu cpu (
        .i_sys_clock            (i_c_sys_clock),
        .i_sys_reset            (i_c_sys_reset),
        .i_u_cpu_data             (data_mem_data),
        .i_u_cpu_ins              (ins_mem_ins),
        .o_u_cpu_ins_addr         (cpu_ins_addr),
        .o_u_cpu_data_addr        (cpu_data_addr),
        .o_u_cpu_write_data       (cpu_write_data),
        .o_u_cpu_mem_wr           (cpu_mem_wr),
        .o_u_cpu_word             (cpu_word)
    );

    u_ins_mem ins_mem (
        .i_sys_clock            (i_c_sys_clock),
        .o_u_ins_mem_ins      (ins_mem_ins),
        .i_u_ins_mem_ins_addr   (cpu_ins_addr),
        .i_u_ins_mem_wr_ins     (i_c_write_ins),
        .i_u_ins_mem_wr_en      (i_c_ins_wr)
    );

    u_data_mem data_mem (
        .i_sys_clock              (i_c_sys_clock),
        .o_u_data_mem_data        (data_mem_data),
        .i_u_data_mem_data_addr   (cpu_data_addr),
        .i_u_data_mem_write_data  (cpu_write_data),
        .i_u_data_mem_mem_wr      (cpu_mem_wr),
        .i_u_data_mem_word        (cpu_word)
    );
    
endmodule
