`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Jing Xuan
// Create Date: 04.09.2025 22:59:17
// File Name: b_ins_mem.sv
// Module Name: b_ins_mem
// Project Name: MIPS ISA Pipeline processor
// Code Type: RTL level 
// Description: Modeling of instruction memory block
//  
//////////////////////////////////////////////////////////////////////////////////
module u_ins_mem(
input logic i_sys_clock,
input logic [31:0] i_u_ins_mem_ins_addr, //instruction address
input logic [31:0] i_u_ins_mem_wr_ins, //data to write
input logic i_u_ins_mem_wr_en, // write enable
output logic [31:0] o_u_ins_mem_ins);

logic [31:0] instructions [4095:0];
logic [16:0] physical_mem_addr;
logic [11:0] physical_mem_loc;


initial begin  //initialize alll instruction memory to 0
    for (int i=0;i<4096;i++)
        instructions [i] = 32'b0;
end

assign physical_mem_addr = {i_u_ins_mem_ins_addr[29:28],i_u_ins_mem_ins_addr[15:14],i_u_ins_mem_ins_addr[11:0]};
assign physical_mem_loc = physical_mem_addr[13:2];
assign o_u_ins_mem_ins = i_u_ins_mem_wr_en ? 32'b0 : instructions [physical_mem_loc];

always_ff @(posedge i_sys_clock)begin

    if(i_u_ins_mem_wr_en)
    instructions[physical_mem_loc] <= i_u_ins_mem_wr_ins;
end
endmodule