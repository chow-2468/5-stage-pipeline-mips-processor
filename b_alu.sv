`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: Chow Bin Lin
//  
// Create Date: 02.09.2025 16:35:18
// File Name: b_alu.sv
// Module Name: b_alu
// Project Name: MIPS ISA Pipeline processor
// Code Type: RTL level 
// Description: Modeling of ALU block
//  
//////////////////////////////////////////////////////////////////////////////////


module b_alu(
input logic[31:0] i_b_alu_operand_1,
input logic[31:0] i_b_alu_operand_2,
input logic[4:0] i_b_alu_shamt,
input logic[3:0] i_b_alu_ctrl,

output logic o_b_alu_branch,
output logic[31:0] o_b_alu_result
    );
    
logic[31:0] adder_temp;
logic[31:0] shift_reg[5:0];
logic[4:0] shift_bit;
logic slt_result;

assign o_b_alu_branch = ~(|o_b_alu_result);
assign shift_bit = &i_b_alu_ctrl? 5'b10000: i_b_alu_shamt;
always_comb begin
    adder_temp = i_b_alu_operand_1 + (i_b_alu_operand_2 ^ {32{i_b_alu_ctrl[1]}})+i_b_alu_ctrl[1];
    shift_reg[0] = i_b_alu_operand_2;
    
    // since in slt case the overflow will only happen when both operand sign are different
    // and neg(msb = 1)<pos(msb = 0) is true(1) 
    // pos(msb = 1)<neg(msb = 0) is false(0)
    // it show the relationship of the result and msb of operand1
    slt_result = (i_b_alu_operand_1[31]^i_b_alu_operand_2[31])?i_b_alu_operand_1[31]:adder_temp[31];
    
    case(i_b_alu_ctrl)
    4'b0000,4'b0010: o_b_alu_result = adder_temp; // add and substract
    4'b0100: o_b_alu_result = i_b_alu_operand_1 & i_b_alu_operand_2;//AND
    4'b0101: o_b_alu_result = i_b_alu_operand_1 | i_b_alu_operand_2;//OR
    4'b0110: o_b_alu_result = i_b_alu_operand_1 ^ i_b_alu_operand_2;//XOR
    4'b0111: o_b_alu_result = ~(i_b_alu_operand_1 | i_b_alu_operand_2);//NOR
    4'b1010: o_b_alu_result = {31'b0,slt_result};//slt
    
    4'b0001,4'b1111: begin // <<
                for (int col = 0; col < 5; col++) begin
                    for (int row = 0; row < 32; row++)begin 
                        if (row < 2**col) 
                    
                            shift_reg[col+1][row] = shift_bit[col] ? 1'b0 : shift_reg[col][row]; 
                        else
                    
                            shift_reg[col+1][row] = shift_bit[col] ? shift_reg[col][row-2**col] : shift_reg[col][row];
                     end
                  end
                  o_b_alu_result = shift_reg[5];
             end
    4'b0011: begin // >>
                for (int col = 0; col < 5; col++) begin
                    for (int row = 0; row < 32; row++)begin 
                        if (row >= 32 - 2**col) 
                    
                            shift_reg[col+1][row] = shift_bit[col] ? 1'b0 : shift_reg[col][row]; 
                        else
                    
                            shift_reg[col+1][row] = shift_bit[col] ? shift_reg[col][row+2**col] : shift_reg[col][row];
                     end
                  end
                  o_b_alu_result = shift_reg[5];
             end               
    default: o_b_alu_result = 'x;
    endcase
end
endmodule
