`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: Chow Bin Lin
//  
// Create Date: 02.09.2025 16:35:18
// File Name: b_reg.sv
// Module Name: b_reg
// Project Name: MIPS ISA Pipeline processor
// Code Type: RTL level 
// Description: Modeling of register block
//  
//////////////////////////////////////////////////////////////////////////////////

module b_reg(
input logic i_sys_clock,
input logic i_sys_reset,

input logic[4:0] i_b_reg_read_addr1,
input logic[4:0] i_b_reg_read_addr2,
input logic[4:0] i_b_reg_wr_addr,
input logic[31:0] i_b_reg_wr_data,
input logic i_b_reg_regwr,

output logic[31:0] o_b_reg_read_data1,
output logic[31:0] o_b_reg_read_data2
);

logic [31:0] register[31:1];
logic [5:0] i;
// read data1 
assign o_b_reg_read_data1 = (i_b_reg_read_addr1 == 5'b0)? 32'b0: register[i_b_reg_read_addr1];
// read data2 
assign o_b_reg_read_data2 = (i_b_reg_read_addr2 == 5'b0)? 32'b0: register[i_b_reg_read_addr2];


always_ff @(negedge i_sys_clock)begin // write
    if(i_sys_reset)
        for(i=0;i<32;i++)
            case(i)
            0:;
            28: register[28]<=32'h1000_4000;
            29: register[29]<=32'h7fff_fffc;
            default:register[i] <= 32'b0;
            endcase
    else begin
        if(i_b_reg_regwr && i_b_reg_wr_addr != 5'b0 ) 
            register[i_b_reg_wr_addr] <= i_b_reg_wr_data; 
    end
end
endmodule