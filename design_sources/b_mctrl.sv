`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: Ng Yu Heng 
//  
// Create Date: 30.08.2025 00:49:53
// File Name: b_mctrl.sv
// Module Name: b_mctrl
// Project Name: MIPS ISA Pipeline processor
// Code Type: RTL level 
// Description: Modeling of Main control block
//  
//////////////////////////////////////////////////////////////////////////////////

module b_mctrl(
    // Inputs
    input  logic [5:0] i_b_mctrl_op,      // Instruction opcode
    input  logic [5:0] i_b_mctrl_funct,   // R-type function field
    
    // Outputs
    output logic       o_b_mctrl_pc_src,   // PC source select
    output logic [1:0] o_b_mctrl_mf,       // Hi/Lo register select
    output logic       o_b_mctrl_ext_op,   // Zero/Sign extend select
    output logic [1:0] o_b_mctrl_jmp,      // Jump instruction indicator
    output logic       o_b_mctrl_mult_en,  // Multiplier enable
    output logic [1:0] o_b_mctrl_reg_dst,  // Destination register select
    output logic       o_b_mctrl_alu_src,  // ALU input source select
    output logic [3:0] o_b_mctrl_alu_op,   // ALU operation class
    output logic       o_b_mctrl_data_sel, // Data memory write select
    output logic       o_b_mctrl_mem_wr,   // Memory write enable
    output logic [1:0] o_b_mctrl_branch,   // Branch instruction indicator
    output logic       o_b_mctrl_word,      // Word or Byte indicator
    output logic       o_b_mctrl_reg_wr,   // Register file write enable
    output logic       o_b_mctrl_mem_to_reg // Writeback source select

    );
    
    always_comb begin
        // Default values
        o_b_mctrl_pc_src   = 1'b0;
        o_b_mctrl_mf       = 2'b00;
        o_b_mctrl_ext_op   = 1'bx;
        o_b_mctrl_jmp      = 2'b00; // 10 = jump register, 01 = jump
        o_b_mctrl_mult_en  = 1'b0;
        o_b_mctrl_reg_dst  = 2'bx; // 00 = $rt, 01 = $rd, 10 = $ra
        o_b_mctrl_alu_src  = 1'b0; 
        o_b_mctrl_alu_op   = 4'bx;
        o_b_mctrl_data_sel = 1'b0;
        o_b_mctrl_mem_wr   = 1'b0;
        o_b_mctrl_branch   = 2'b00; //1st bit = branch, 2nd bit choose bne or beq
        o_b_mctrl_word     = 1'bx;
        o_b_mctrl_reg_wr   = 1'b0;
        o_b_mctrl_mem_to_reg = 1'b0;
        
        case (i_b_mctrl_op)
            // R-type instructions
            6'b000000: begin
                
                case (i_b_mctrl_funct)
                    6'b011001: begin // multu
                        o_b_mctrl_mult_en = 1'b1;
                        o_b_mctrl_reg_dst = 2'b01;
                        o_b_mctrl_reg_wr  = 1'b1;
                    end
                    
                    6'b010000: begin // mfhi
                        o_b_mctrl_mf      = 2'b11;
                        o_b_mctrl_reg_dst = 2'b01;
                        o_b_mctrl_alu_op  = 4'b0000; // add
                        o_b_mctrl_reg_wr  = 1'b1;
                    end
                    
                    6'b010010: begin // mflo
                        o_b_mctrl_mf      = 2'b01;
                        o_b_mctrl_reg_dst = 2'b01;
                        o_b_mctrl_alu_op  = 4'b0000; // add
                        o_b_mctrl_reg_wr  = 1'b1;
                    end
                    
                    6'b001000: begin // jr
                        o_b_mctrl_jmp     = 2'b10;
                        o_b_mctrl_reg_dst = 2'bxx;
                    end
                    
                    6'b001001: begin // jalr
                        o_b_mctrl_jmp     = 2'b10;
                        o_b_mctrl_reg_dst = 2'b01;
                        o_b_mctrl_data_sel= 1'b1;
                        o_b_mctrl_reg_wr  = 1'b1;
                    end
                    
                    // jr and jalr would need specific funct codes
                    default: begin // Other R-type
                        o_b_mctrl_reg_dst = 2'b01;
                        o_b_mctrl_alu_op  = 4'b1000; // R-type
                        o_b_mctrl_reg_wr  = 1'b1;
                    end
                endcase
            end
            
            // Load/Store instructions
            6'b100011: begin // lw
                o_b_mctrl_ext_op   = 1'b1;
                o_b_mctrl_reg_dst  = 2'b00;
                o_b_mctrl_alu_src  = 1'b1;
                o_b_mctrl_alu_op   = 4'b0000; // add
                o_b_mctrl_reg_wr   = 1'b1;
                o_b_mctrl_mem_to_reg = 1'b1;
                o_b_mctrl_word     = 1'b1;
            end
            
            6'b101011: begin // sw
                o_b_mctrl_ext_op   = 1'b1;
                o_b_mctrl_alu_src  = 1'b1;
                o_b_mctrl_alu_op   = 4'b0000; // add
                o_b_mctrl_mem_wr   = 1'b1;
                o_b_mctrl_word     = 1'b1;
                o_b_mctrl_mem_to_reg = 1'bx;
            end
            
            6'b100000: begin // lb
                o_b_mctrl_ext_op   = 1'b1;
                o_b_mctrl_reg_dst  = 2'b00;
                o_b_mctrl_alu_src  = 1'b1;
                o_b_mctrl_alu_op   = 4'b0000; // add
                o_b_mctrl_reg_wr   = 1'b1;
                o_b_mctrl_mem_to_reg = 1'b1;
                o_b_mctrl_word     = 1'b0;
            end
            
            6'b101000: begin // sb
                o_b_mctrl_ext_op   = 1'b1;
                o_b_mctrl_alu_src  = 1'b1;
                o_b_mctrl_alu_op   = 4'b0000; // add
                o_b_mctrl_mem_wr   = 1'b1;
                o_b_mctrl_word     = 1'b0;
                o_b_mctrl_mem_to_reg = 1'bx;
            end
            
            // I-type
            6'b001000: begin // addi
                o_b_mctrl_ext_op   = 1'b1;
                o_b_mctrl_reg_dst  = 2'b00;
                o_b_mctrl_alu_src  = 1'b1;
                o_b_mctrl_alu_op   = 4'b0000; // add
                o_b_mctrl_reg_wr   = 1'b1;
            end
            
            6'b001100: begin // andi
                o_b_mctrl_ext_op   = 1'b0; // zero extend
                o_b_mctrl_reg_dst  = 2'b00;
                o_b_mctrl_alu_src  = 1'b1;
                o_b_mctrl_alu_op   = 4'b0100; // and
                o_b_mctrl_reg_wr   = 1'b1;
            end
            
            6'b001101: begin // ori
                o_b_mctrl_ext_op   = 1'b0; // zero extend
                o_b_mctrl_reg_dst  = 2'b00;
                o_b_mctrl_alu_src  = 1'b1;
                o_b_mctrl_alu_op   = 4'b0101; // or
                o_b_mctrl_reg_wr   = 1'b1;
            end
            
            6'b001010: begin // slti
                o_b_mctrl_ext_op   = 1'b1;
                o_b_mctrl_reg_dst  = 2'b00;
                o_b_mctrl_alu_src  = 1'b1;
                o_b_mctrl_alu_op   = 4'b0001; // sub (for comparison)
                o_b_mctrl_reg_wr   = 1'b1;
            end
            
            // Branch instructions
            6'b000100: begin // beq
                o_b_mctrl_pc_src   = 1'b1;
                o_b_mctrl_alu_op   = 4'b0010; // sub for comparison
                o_b_mctrl_branch   = 2'b11; //beq
                o_b_mctrl_mem_to_reg = 1'bx;
            end
            
            6'b000101: begin // bne
                o_b_mctrl_pc_src   = 1'b1;
                o_b_mctrl_alu_op   = 4'b0010; // sub for comparison
                o_b_mctrl_branch   = 2'b10; //bne
                o_b_mctrl_mem_to_reg = 1'bx;
            end
            
            // Jump instructions
            6'b000010: begin // j
                o_b_mctrl_pc_src   = 1'b1;
                o_b_mctrl_jmp      = 2'b01;
                o_b_mctrl_alu_src  = 1'bx;
                o_b_mctrl_mem_to_reg = 1'bx;
            end
            
            6'b000011: begin // jal
                o_b_mctrl_pc_src   = 1'b1;
                o_b_mctrl_jmp      = 2'b01;
                o_b_mctrl_reg_dst  = 2'b10; // $ra
                o_b_mctrl_alu_src  = 1'bx;
                o_b_mctrl_data_sel= 1'b1;
                o_b_mctrl_reg_wr   = 1'b1;
            end
            
            6'b001111: begin // lui
                o_b_mctrl_alu_src  = 1'b1;  
                o_b_mctrl_alu_op   = 4'b0111; // shift left 16
                o_b_mctrl_reg_dst  = 2'b00;  
                o_b_mctrl_reg_wr   = 1'b1;   
                o_b_mctrl_ext_op   = 1'bx;   // Don't care
            end
            
            default: begin
                // NOP
                o_b_mctrl_alu_op = 4'b0000;
            end
        endcase
    end

endmodule
