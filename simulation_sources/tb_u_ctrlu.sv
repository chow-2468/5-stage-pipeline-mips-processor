`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: Ng Yu Heng 
//  
// Create Date: 31.08.2025 23:58:27
// File Name: tb_u_ctrlu.sv 
// Module Name: tb_u_ctrlu
// Project Name: MIPS ISA Pipeline processor
// Code Type: Behavioural 
// Description: Testbench for Control unit block
//  
//////////////////////////////////////////////////////////////////////////////////

module tb_u_ctrlu();
    // Inputs
    logic [5:0] tb_i_u_ctrlu_op;
    logic [5:0] tb_i_u_ctrlu_funct;
    
    // Outputs
    logic       tb_o_u_ctrlu_pc_src;
    logic [1:0] tb_o_u_ctrlu_mf;
    logic       tb_o_u_ctrlu_ext_op;
    logic [1:0] tb_o_u_ctrlu_jmp;
    logic       tb_o_u_ctrlu_mult_en;
    logic [1:0] tb_o_u_ctrlu_reg_dst;
    logic       tb_o_u_ctrlu_alu_src;
    logic [3:0] tb_o_u_ctrlu_alu_ctr;
    logic       tb_o_u_ctrlu_data_sel;
    logic       tb_o_u_ctrlu_mem_wr;
    logic [1:0] tb_o_u_ctrlu_branch;
    logic       tb_o_u_ctrlu_word;
    logic       tb_o_u_ctrlu_reg_wr;
    logic       tb_o_u_ctrlu_mem_to_reg;
    
    // Clock and cycle definition
    parameter CC = 10; // 10ns per clock cycle
    logic clk;
    
    // Instantiate DUT
    u_ctrlu dut (
        .i_u_ctrlu_op(tb_i_u_ctrlu_op),
        .i_u_ctrlu_funct(tb_i_u_ctrlu_funct),
        .o_u_ctrlu_pc_src(tb_o_u_ctrlu_pc_src),
        .o_u_ctrlu_mf(tb_o_u_ctrlu_mf),
        .o_u_ctrlu_ext_op(tb_o_u_ctrlu_ext_op),
        .o_u_ctrlu_jmp(tb_o_u_ctrlu_jmp),
        .o_u_ctrlu_mult_en(tb_o_u_ctrlu_mult_en),
        .o_u_ctrlu_reg_dst(tb_o_u_ctrlu_reg_dst),
        .o_u_ctrlu_alu_src(tb_o_u_ctrlu_alu_src),
        .o_u_ctrlu_alu_ctr(tb_o_u_ctrlu_alu_ctr),
        .o_u_ctrlu_data_sel(tb_o_u_ctrlu_data_sel),
        .o_u_ctrlu_mem_wr(tb_o_u_ctrlu_mem_wr),
        .o_u_ctrlu_branch(tb_o_u_ctrlu_branch),
        .o_u_ctrlu_word(tb_o_u_ctrlu_word),
        .o_u_ctrlu_reg_wr(tb_o_u_ctrlu_reg_wr),
        .o_u_ctrlu_mem_to_reg(tb_o_u_ctrlu_mem_to_reg)
    );
    
    // Clock generation
    always #(CC/2) clk = ~clk;
    
    initial begin
        // Initialize
        clk = 0;
        tb_i_u_ctrlu_op = 6'bx;
        tb_i_u_ctrlu_funct = 6'bx;
        
        // Wait 2 cycles
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 1: R-type add
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b100000;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 2: R-type sub
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b100010;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 3: R-type and
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b100100;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 4: R-type or
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b100101;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 5: R-type xor
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b100110;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 6: R-type nor
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b100111;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 7: R-type slt
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b101010;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 8: R-type sll
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b000000;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 9: R-type srl
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b000010;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 10: R-type multu
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b011001;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 11: R-type mfhi
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b010000;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 12: R-type mflo
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b010010;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 13: R-type jr
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b001000;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 14: R-type jalr
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000000;
        tb_i_u_ctrlu_funct = 6'b001001;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 15: I-type lw
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b100011;
        tb_i_u_ctrlu_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 16: I-type sw
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b101011;
        tb_i_u_ctrlu_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 17: I-type lb
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b100000;
        tb_i_u_ctrlu_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 18: I-type sb
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b101000;
        tb_i_u_ctrlu_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 19: I-type addi
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b001000;
        tb_i_u_ctrlu_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 20: I-type andi
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b001100;
        tb_i_u_ctrlu_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 21: I-type ori
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b001101;
        tb_i_u_ctrlu_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 22: I-type slti
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b001010;
        tb_i_u_ctrlu_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 23: I-type beq
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000100;
        tb_i_u_ctrlu_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 24: I-type bne
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000101;
        tb_i_u_ctrlu_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 25: J-type j
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000010;
        tb_i_u_ctrlu_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 26: J-type jal
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b000011;
        tb_i_u_ctrlu_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 27: I-type lui
        //----------------------------------------- 
        tb_i_u_ctrlu_op = 6'b001111;
        tb_i_u_ctrlu_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        // Finish simulation
        repeat(2) @(negedge clk);
        $finish;
    end
    
endmodule
