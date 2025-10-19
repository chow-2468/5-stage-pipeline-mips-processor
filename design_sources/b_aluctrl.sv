`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: Ng Yu Heng 
//  
// Create Date: 31.08.2025 00:41:40
// File Name: b_aluctrl.sv
// Module Name: b_aluctrl 
// Project Name: MIPS ISA Pipeline processor
// Code Type: RTL level 
// Description: Modeling of ALU control block
//  
//////////////////////////////////////////////////////////////////////////////////

module b_aluctrl(
    // Inputs
    input  logic [3:0] i_b_aluctrl_alu_op,    // ALU operation code from Main Control
    input  logic [5:0] i_b_aluctrl_funct,     // R-type function field
    
    // Outputs
    output logic [3:0] o_b_aluctrl_alu_ctr    // Specific ALU/shifter operation
);

always_comb begin
        // Default output is xxxx for instructions that don't need ALU
        o_b_aluctrl_alu_ctr = 4'bxxxx;
        
        // R-type instructions (when ALU op starts with 1)
        if (i_b_aluctrl_alu_op[3] == 1'b1) begin
            case (i_b_aluctrl_funct)
                6'b100000: o_b_aluctrl_alu_ctr = 4'b0000; // add
                6'b100010: o_b_aluctrl_alu_ctr = 4'b0010; // sub
                6'b100100: o_b_aluctrl_alu_ctr = 4'b0100; // and
                6'b100101: o_b_aluctrl_alu_ctr = 4'b0101; // or
                6'b100110: o_b_aluctrl_alu_ctr = 4'b0110; // xor
                6'b100111: o_b_aluctrl_alu_ctr = 4'b0111; // nor
                6'b101010: o_b_aluctrl_alu_ctr = 4'b1010; // slt
                6'b000000: o_b_aluctrl_alu_ctr = 4'b0001; // sll
                6'b000010: o_b_aluctrl_alu_ctr = 4'b0011; // srl
                // multu, jr, jalr remain xxxx (default)
            endcase
        end
        // I-type and other instructions
        else begin
            case (i_b_aluctrl_alu_op)
                4'b0000: o_b_aluctrl_alu_ctr = 4'b0000; // lw, sw, lb, sb, addi, mfhi, mflo
                4'b0100: o_b_aluctrl_alu_ctr = 4'b0100; // andi
                4'b0101: o_b_aluctrl_alu_ctr = 4'b0101; // ori
                4'b0001: o_b_aluctrl_alu_ctr = 4'b1010; // slti
                4'b0010: o_b_aluctrl_alu_ctr = 4'b0010; // beq, bne
                4'b0111: o_b_aluctrl_alu_ctr = 4'b1111; // lui
                // default remains xxxx for j, jal
            endcase
        end
    end

endmodule