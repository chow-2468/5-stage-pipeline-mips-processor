`timescale 1s / 1ps

////////////////////////////////////////////////////////////////////////////////// 
// Author: Goh Xuan Hui
//  
// Create Date: 06.09.2025 01:22:23
// File Name: b_mult.sv
// Module Name: b_mult
// Project Name: MIPS ISA Pipeline processor
// Code Type: RTL level 
// Description: Modeling of sequential multiplier block
//  
//////////////////////////////////////////////////////////////////////////////////

    
 module b_mult(
  input  logic        i_sys_clock,
  input  logic        i_sys_reset,
  input  logic        i_b_mult_start,
  input  logic [31:0] i_b_mult_a_in,
  input  logic [31:0] i_b_mult_b_in,
  output logic        o_b_mult_done,
  output logic [31:0] o_b_mult_hi,
  output logic [31:0] o_b_mult_lo
);

  logic active;
  logic [5:0] count;   // 0-31 step
  logic [31:0] a_reg;
  logic [31:0] b_reg;
  logic [63:0] prod;

  // Sequential process
  always_ff @(posedge i_sys_clock or posedge i_sys_reset) begin
    if (i_sys_reset) begin
      active <= 1'b0;
      count  <= 6'd0;
      a_reg  <= 32'd0;
      b_reg  <= 32'd0;
      prod   <= 64'd0;
      o_b_mult_hi     <= 32'd0;
      o_b_mult_lo     <= 32'd0;
      o_b_mult_done   <= 1'b0;
    end else begin
      o_b_mult_done <= 1'b0; // default

      if (i_b_mult_start && !active) begin
        // Latch inputs and start
        active <= 1'b1;
        count  <= 6'd0;
        a_reg  <= i_b_mult_a_in;
        b_reg  <= i_b_mult_b_in;
        prod   <= 64'd0;
      end else if (active) begin
          
        if (b_reg[0] == 1'b1) begin
          prod <= prod + ({32'd0, a_reg} << count);  
        end
        // =====================================================
        
        // Shift left multiplicand, right multiplier
        b_reg <= b_reg >> 1;
        count <= count + 6'd1;

        // After 32 steps, finish
        if (count == 6'd32) begin  
          active <= 1'b0;
          o_b_mult_done   <= 1'b1;
          o_b_mult_hi     <= prod[63:32];
          o_b_mult_lo     <= prod[31:0];
        end
      end
    end
  end

endmodule