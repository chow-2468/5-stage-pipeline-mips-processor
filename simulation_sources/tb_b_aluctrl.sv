`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: Ng Yu Heng 
//  
// Create Date: 31.08.2025 00:49:43
// File Name: tb_b_aluctrl.sv 
// Module Name: tb_b_aluctrl
// Project Name: MIPS ISA Pipeline processor
// Code Type: Behavioural 
// Description: Testbench for ALU control block
//  
//////////////////////////////////////////////////////////////////////////////////

module tb_b_aluctrl();
    // Inputs
    logic [3:0] tb_i_b_aluctrl_alu_op;
    logic [5:0] tb_i_b_aluctrl_funct;
    
    // Outputs
    logic [3:0] tb_o_b_aluctrl_alu_ctrl;
    
    // Clock and cycle definition
    parameter CC = 10; // 10ns per clock cycle
    logic clk;
    
    // Instantiate DUT
    b_aluctrl dut (
        .i_b_aluctrl_alu_op(tb_i_b_aluctrl_alu_op),
        .i_b_aluctrl_funct(tb_i_b_aluctrl_funct),
        .o_b_aluctrl_alu_ctr(tb_o_b_aluctrl_alu_ctrl)
    );
    
    // Clock generation
    always #(CC/2) clk = ~clk;
    
    initial begin
        // Initialize
        clk = 0;
        tb_i_b_aluctrl_alu_op = 4'b0;
        tb_i_b_aluctrl_funct = 6'b0;
        
        // Wait 2 cycles
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 1: R-type add
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b1xxx;
        tb_i_b_aluctrl_funct = 6'b100000;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 2: R-type sub
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b1xxx;
        tb_i_b_aluctrl_funct = 6'b100010;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 3: R-type and
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b1xxx;
        tb_i_b_aluctrl_funct = 6'b100100;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 4: R-type or
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b1xxx;
        tb_i_b_aluctrl_funct = 6'b100101;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 5: R-type xor
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b1xxx;
        tb_i_b_aluctrl_funct = 6'b100110;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 6: R-type nor
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b1xxx;
        tb_i_b_aluctrl_funct = 6'b100111;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 7: R-type slt
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b1xxx;
        tb_i_b_aluctrl_funct = 6'b101010;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 8: R-type sll
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b1xxx;
        tb_i_b_aluctrl_funct = 6'b000000;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 9: R-type srl
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b1xxx;
        tb_i_b_aluctrl_funct = 6'b000010;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 10: R-type mfhi, mflo
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b0000;
        tb_i_b_aluctrl_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 11: I-type lw, sw, lb, sb, addi
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b0000;
        tb_i_b_aluctrl_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 12: I-type andi
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b0100;
        tb_i_b_aluctrl_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 13: I-type ori
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b0101;
        tb_i_b_aluctrl_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 14: I-type slti
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b0001;
        tb_i_b_aluctrl_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 15: beq, bne
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b0010;
        tb_i_b_aluctrl_funct = 6'bx;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 16: jr
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b1xxx;
        tb_i_b_aluctrl_funct = 6'b001000;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 17: jalr
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b1xxx;
        tb_i_b_aluctrl_funct = 6'b001001;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 18: multu
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b1xxx;
        tb_i_b_aluctrl_funct = 6'b011001;
        repeat(2) @(negedge clk);
        
        //----------------------------------------- 
        // Test Case 19: j
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'bx;
        tb_i_b_aluctrl_funct = 6'bx;
        repeat(2) @(negedge clk);

        //----------------------------------------- 
        // Test Case 20: lui
        //----------------------------------------- 
        tb_i_b_aluctrl_alu_op = 4'b0111;
        tb_i_b_aluctrl_funct = 6'bx;
        repeat(2) @(negedge clk);

        
        // Finish simulation
        repeat(2) @(negedge clk);
        $finish;
    end
    
endmodule
