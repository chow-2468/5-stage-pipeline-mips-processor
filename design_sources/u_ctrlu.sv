`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: Ng Yu Heng 
//  
// Create Date: 31.08.2025 19:55:10
// File Name: u_ctrlu.sv
// Module Name: u_ctrlu
// Project Name: MIPS ISA Pipeline processor
// Code Type: RTL level
// Description: Modeling of Control Unit block
//  
//////////////////////////////////////////////////////////////////////////////////
module u_ctrlu(
    // Inputs
    input  logic [5:0] i_u_ctrlu_op,      // Instruction opcode
    input  logic [5:0] i_u_ctrlu_funct,   // R-type function field
    
    // Outputs
    output logic       o_u_ctrlu_pc_src,   // PC source select
    output logic [1:0] o_u_ctrlu_mf,      // Hi/Lo register select
    output logic       o_u_ctrlu_ext_op,  // Zero/Sign extend select
    output logic [1:0] o_u_ctrlu_jmp,     // Jump instruction indicator
    output logic       o_u_ctrlu_mult_en, // Multiplier enable
    output logic [1:0] o_u_ctrlu_reg_dst, // Destination register select
    output logic       o_u_ctrlu_alu_src, // ALU input source select
    output logic [3:0] o_u_ctrlu_alu_ctr, // ALU operation control
    output logic       o_u_ctrlu_data_sel,// PC+4 select
    output logic       o_u_ctrlu_mem_wr,  // Memory write enable
    output logic [1:0] o_u_ctrlu_branch,  // Branch instruction indicator
    output logic       o_u_ctrlu_word,      // Word or Byte indicator
    output logic       o_u_ctrlu_reg_wr,  // Register file write enable
    output logic       o_u_ctrlu_mem_to_reg // Writeback source select
    );
    
    // Internal signals between main control and ALU control
    logic [3:0] main_ctrl_alu_op;  // ALU operation code from main control to ALU control
    
    // Instantiate Main Control Block
    b_mctrl main_ctrl(
        // Inputs
        .i_b_mctrl_op(i_u_ctrlu_op),
        .i_b_mctrl_funct(i_u_ctrlu_funct),
        
        // Outputs
        .o_b_mctrl_pc_src(o_u_ctrlu_pc_src),
        .o_b_mctrl_mf(o_u_ctrlu_mf),
        .o_b_mctrl_ext_op(o_u_ctrlu_ext_op),
        .o_b_mctrl_jmp(o_u_ctrlu_jmp),
        .o_b_mctrl_mult_en(o_u_ctrlu_mult_en),
        .o_b_mctrl_reg_dst(o_u_ctrlu_reg_dst),
        .o_b_mctrl_alu_src(o_u_ctrlu_alu_src),
        .o_b_mctrl_alu_op(main_ctrl_alu_op),  // Connected to ALU control
        .o_b_mctrl_data_sel(o_u_ctrlu_data_sel),
        .o_b_mctrl_mem_wr(o_u_ctrlu_mem_wr),
        .o_b_mctrl_branch(o_u_ctrlu_branch),
        .o_b_mctrl_word(o_u_ctrlu_word),
        .o_b_mctrl_reg_wr(o_u_ctrlu_reg_wr),
        .o_b_mctrl_mem_to_reg(o_u_ctrlu_mem_to_reg)
    );
    
    // Instantiate ALU Control Block
    b_aluctrl alu_ctrl (
        // Inputs
        .i_b_aluctrl_alu_op(main_ctrl_alu_op),  // From main control
        .i_b_aluctrl_funct(i_u_ctrlu_funct),    
        // Outputs
        .o_b_aluctrl_alu_ctr(o_u_ctrlu_alu_ctr) 
    );
    
endmodule
