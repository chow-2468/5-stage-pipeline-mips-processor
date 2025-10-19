`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Author: Chow Bin Lin
//  
// Create Date: 02.09.2025 16:35:18
// File Name: tb_b_reg.sv
// Module Name: tb_b_reg
// Project Name: MIPS ISA Pipeline processor
// Code Type: Behavioural  
// Description: Testbench for Register block
//  
//////////////////////////////////////////////////////////////////////////////////


module tb_b_reg(
    );
    parameter CC = 10;
    logic clk;
    logic[3:0] i;
    logic[3:0] test_case;
    
    
    logic tb_i_sys_clock;
    logic tb_i_sys_reset;
    logic[4:0] tb_i_b_reg_read_addr1;
    logic[4:0] tb_i_b_reg_read_addr2;
    logic[4:0] tb_i_b_reg_wr_addr;
    logic[31:0] tb_i_b_reg_wr_data;
    logic tb_i_b_reg_regwr;
    logic[31:0] tb_o_b_reg_read_data1;
    logic[31:0] tb_o_b_reg_read_data2;
    
    b_reg reg_file(
    .i_sys_clock(tb_i_sys_clock),
    .i_sys_reset(tb_i_sys_reset),
    
    .i_b_reg_read_addr1(tb_i_b_reg_read_addr1),
    .i_b_reg_read_addr2(tb_i_b_reg_read_addr2),
    .i_b_reg_wr_addr(tb_i_b_reg_wr_addr),
    .i_b_reg_wr_data(tb_i_b_reg_wr_data),
    .i_b_reg_regwr(tb_i_b_reg_regwr),
    
    .o_b_reg_read_data1(tb_o_b_reg_read_data1),
    .o_b_reg_read_data2(tb_o_b_reg_read_data2)
    );
    
    always #(CC/2) clk = ~clk;
    assign tb_i_sys_clock = clk;
    
    initial begin
        clk = 1;
        
        for( i = 1; i <5 ; i++)@(posedge clk)
        test_case = i;
    end
    
    always_comb begin
    
    case(test_case)
    1:begin  
    tb_i_sys_reset =1'b1;
    tb_i_b_reg_read_addr1 = 5'b0_0000;
    tb_i_b_reg_read_addr2 = 5'b0_0000;
    tb_i_b_reg_wr_addr = 5'b0_0000;
    tb_i_b_reg_wr_data = 32'h0000_0000;
    tb_i_b_reg_regwr = 1'b0;
    end
    2:begin
    tb_i_sys_reset =1'b0;
    tb_i_b_reg_read_addr1 = 5'b0_1000;
    tb_i_b_reg_read_addr2 = 5'b0_0000;
    tb_i_b_reg_wr_addr = 5'b0_1000;
    tb_i_b_reg_wr_data = 32'h0000_1234;
    tb_i_b_reg_regwr = 1'b1;
    end
    3:
    begin
    tb_i_sys_reset =1'b0;
    tb_i_b_reg_read_addr1 = 5'b0_1000;
    tb_i_b_reg_read_addr2 = 5'b0_1001;
    tb_i_b_reg_wr_addr = 5'b0_1001;
    tb_i_b_reg_wr_data = 32'h0000_5678;
    tb_i_b_reg_regwr = 1'b0;
    end
    4:
    begin
    tb_i_sys_reset =1'b0;
    tb_i_b_reg_read_addr1 = 5'b0_0000;
    tb_i_b_reg_read_addr2 = 5'b0_0000;
    tb_i_b_reg_wr_addr = 5'b0_0000;
    tb_i_b_reg_wr_data = 32'h0000_9876;
    tb_i_b_reg_regwr = 1'b1; 
    end
    endcase
    end
    
endmodule
