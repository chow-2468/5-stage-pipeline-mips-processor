`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: Chow Bin Lin
//  
// Create Date: 02.09.2025 16:35:18
// File Name: tb_b_alu.sv
// Module Name: tb_b_alu
// Project Name: MIPS ISA Pipeline processor
// Code Type: Behavioural  
// Description: Testbench for ALU block
//  
//////////////////////////////////////////////////////////////////////////////////


module tb_b_alu();
    
    parameter CC = 10;
    logic clk;
    logic[3:0] test_case;
    logic[3:0] i;
    
    logic[31:0] tb_i_b_alu_operand_1, tb_i_b_alu_operand_2;
    logic[4:0] tb_i_b_alu_shamt;
    logic[3:0] tb_i_b_alu_ctrl;
    logic tb_o_b_alu_branch;
    logic[31:0] tb_o_b_alu_result;
     
    b_alu alu(
    .i_b_alu_operand_1(tb_i_b_alu_operand_1),
    .i_b_alu_operand_2(tb_i_b_alu_operand_2),
    .i_b_alu_shamt(tb_i_b_alu_shamt),
    .i_b_alu_ctrl(tb_i_b_alu_ctrl),
    .o_b_alu_branch(tb_o_b_alu_branch),
    .o_b_alu_result(tb_o_b_alu_result));
    
    always #(CC/2) clk = ~clk;
    
    //to chooose the input
    initial begin
        clk = 1;
        
        for( i = 1; i <11 ; i++)@(posedge clk)
        test_case = i;
    end
    
    always_comb begin
    case(test_case)
    //----------------------------------------- 
    // Test Case 1: Add
    //----------------------------------------- 
    1:begin
    tb_i_b_alu_operand_1 = 32'h0000_0001;
    
    tb_i_b_alu_operand_2 = 32'h0000_0002;
    
    tb_i_b_alu_shamt = 5'b0_0000;
    
    tb_i_b_alu_ctrl = 4'b0000;
    
    end
    //----------------------------------------- 
    // Test Case 2: Subtract
    //----------------------------------------- 
    2:begin
    tb_i_b_alu_operand_1 = 32'h0000_0001;
    
    tb_i_b_alu_operand_2 = 32'h0000_0002;
    
    tb_i_b_alu_shamt = 5'b0_0000;
    
    tb_i_b_alu_ctrl = 4'b0010;
    
    end
    
    //----------------------------------------- 
    // Test Case 3: Bitwise AND
    //----------------------------------------- 
    3:begin
    tb_i_b_alu_operand_1 = 32'h0000_0001;
    
    tb_i_b_alu_operand_2 = 32'h0000_0002;
    
    tb_i_b_alu_shamt = 5'b0_0000;
    
    tb_i_b_alu_ctrl = 4'b0100;
    
    end
    
    
    //----------------------------------------- 
    // Test Case 4: Bitwise OR
    //----------------------------------------- 
    4:begin
    tb_i_b_alu_operand_1 = 32'h0000_0001;
    
    tb_i_b_alu_operand_2 = 32'h0000_0002;
    
    tb_i_b_alu_shamt = 5'b0_0000;
    
    tb_i_b_alu_ctrl = 4'b0101;
    
    end
    
    
    //----------------------------------------- 
    // Test Case 5: Bitwise XOR
    //----------------------------------------- 
    5:begin
    tb_i_b_alu_operand_1 = 32'h0000_0001;
    
    tb_i_b_alu_operand_2 = 32'h0000_0002;
    
    tb_i_b_alu_shamt = 5'b0_0000;
    
    tb_i_b_alu_ctrl = 4'b0110;
    
    end
    
    
    //----------------------------------------- 
    // Test Case 6: Bitwise NOR
    //----------------------------------------- 
    6:begin
    tb_i_b_alu_operand_1 = 32'h0000_0001;
    
    tb_i_b_alu_operand_2 = 32'h0000_0002;
    
    tb_i_b_alu_shamt = 5'b0_0000;
    
    tb_i_b_alu_ctrl = 4'b0111;
    
    end
    
    
    //----------------------------------------- 
    // Test Case 7: Set on less than
    //----------------------------------------- 
    7:begin
    tb_i_b_alu_operand_1 = 32'h0000_0001;
    
    tb_i_b_alu_operand_2 = 32'h0000_0002;
    
    tb_i_b_alu_shamt = 5'b0_0000;
    
    tb_i_b_alu_ctrl = 4'b1010;
    
    end
    
    
    //----------------------------------------- 
    // Test Case 8: Swift left logical
    //----------------------------------------- 
    8:begin
    tb_i_b_alu_operand_1 = 32'h0000_0000;
    
    tb_i_b_alu_operand_2 = 32'h0000_0002;
    
    tb_i_b_alu_shamt = 5'b0_0010;
    
    tb_i_b_alu_ctrl = 4'b0001;
    
    end
    
    
    //----------------------------------------- 
    // Test Case 9: Swift right logical
    //----------------------------------------- 
    9:begin
    tb_i_b_alu_operand_1 = 32'h0000_0000;
    
    tb_i_b_alu_operand_2 = 32'h0000_0200;
    
    tb_i_b_alu_shamt = 5'b0_0010;
    
    tb_i_b_alu_ctrl = 4'b0011;
    
    end
    
    
    //----------------------------------------- 
    // Test Case 10: load upper immediate
    //----------------------------------------- 
    10:begin
    tb_i_b_alu_operand_1 = 32'h0000_0000;
    
    tb_i_b_alu_operand_2 = 32'h0000_FFFF;
    
    tb_i_b_alu_shamt = 5'b0_0000;
    
    tb_i_b_alu_ctrl = 4'b1111;
    end
    default:;
    endcase
    end

endmodule
