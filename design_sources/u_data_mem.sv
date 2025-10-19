`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Jing Xuan
// Create Date: 04.09.2025 22:59:17
// File Name: b_data_mem.sv
// Module Name: b_data_mem
// Project Name: MIPS ISA Pipeline processor
// Code Type: RTL level 
// Description: Modeling of data memory block
//  
//////////////////////////////////////////////////////////////////////////////////
module u_data_mem(
input logic i_sys_clock,
input logic [31:0] i_u_data_mem_data_addr,
input logic [31:0] i_u_data_mem_write_data,
input logic i_u_data_mem_mem_wr,
input logic i_u_data_mem_word,
output logic [31:0] o_u_data_mem_data
);

logic [31:0] data [2047:0];
logic [15:0] physical_data_addr;
logic [10:0] physical_data_loc;
logic [1:0] byte_no;
logic [31:0] byte_read;


initial begin  //initialize alll data memory to 0
    for (int i=0;i<2048;i++)
        data [i] = 32'b0;
end

assign physical_data_addr = {i_u_data_mem_data_addr[29:28],i_u_data_mem_data_addr[15:14],i_u_data_mem_data_addr[11:0]};
assign physical_data_loc = physical_data_addr[12:2];
assign byte_no = i_u_data_mem_data_addr[1:0];
assign byte_read = byte_no[1] ? (byte_no[0]? {24'b0,data [physical_data_loc][31:24]}: {24'b0,data [physical_data_loc][23:16]}) : (byte_no[0]? {24'b0,data [physical_data_loc][15:8]}: {24'b0,data [physical_data_loc][7:0]}) ;
assign o_u_data_mem_data = i_u_data_mem_mem_wr ? 32'b0 : (i_u_data_mem_word ? data [physical_data_loc] : byte_read) ;


always_ff @(posedge i_sys_clock)begin  
    if (i_u_data_mem_mem_wr)begin
        if (i_u_data_mem_word) //write word
            data [physical_data_loc] <= i_u_data_mem_write_data;

        else begin //write byte
            case (byte_no)
            2'b00: data [physical_data_loc][7:0] <= i_u_data_mem_write_data[7:0];
            2'b01: data [physical_data_loc][15:8] <= i_u_data_mem_write_data[7:0];
            2'b10: data [physical_data_loc][23:16] <= i_u_data_mem_write_data[7:0];
            2'b11: data [physical_data_loc][31:24] <= i_u_data_mem_write_data[7:0];
            default: data [physical_data_loc] <= data [physical_data_loc];
            endcase   
        end
    end      
end
endmodule
