////////////////////////////////////////////////////////////////////////////////// 
// Author: Goh Xuan Hui 
// Create Date: 06.09.2025 01:33:10 
// File Name: tb_b_mult.sv 
// Module Name: tb_b_mult 
// Project Name: MIPS ISA Pipeline processor 
// Code Type: Behavioural 
// Description: Testbench for sequential multiplier block 
//////////////////////////////////////////////////////////////////////////////////

module tb_b_mult; 
logic tb_i_sys_clock;
 logic tb_i_sys_reset;
 logic tb_i_b_mult_start;
 logic [31:0] tb_i_b_mult_a_in;
 logic [31:0] tb_i_b_mult_b_in;
 logic tb_o_b_mult_done;
 logic [31:0] tb_o_b_mult_hi;
 logic [31:0] tb_o_b_mult_lo; 
b_mult uut (
 .i_sys_clock(tb_i_sys_clock),
 .i_sys_reset(tb_i_sys_reset),
 .i_b_mult_start(tb_i_b_mult_start),
 .i_b_mult_a_in(tb_i_b_mult_a_in),
 .i_b_mult_b_in(tb_i_b_mult_b_in),
 .o_b_mult_done(tb_o_b_mult_done),
 .o_b_mult_hi(tb_o_b_mult_hi),
 .o_b_mult_lo(tb_o_b_mult_lo)
 ); 
// Clock generation
 initial tb_i_sys_clock = 0;
 always #5 tb_i_sys_clock = ~tb_i_sys_clock; 
initial begin
 // Initialize & reset
 tb_i_sys_reset = 1;
 tb_i_b_mult_start = 0;
 tb_i_b_mult_a_in = 0;
 tb_i_b_mult_b_in = 0; 
repeat(2) @(posedge tb_i_sys_clock); // Hold reset for 2 cycles  
tb_i_sys_reset = 0;  

// -------------------------  
// Test 1: Small numbers (3 * 5 = 15)  
tb_i_b_mult_a_in = 32'd3;  
tb_i_b_mult_b_in = 32'd5;  
tb_i_b_mult_start = 1;  
@(posedge tb_i_sys_clock);  
tb_i_b_mult_start = 0;  
wait(tb_o_b_mult_done == 1);  
@(posedge tb_i_sys_clock);  

// -------------------------  
// Test 2: Large numbers (12345 * 6789 = 83810205)  
tb_i_b_mult_a_in = 32'd12345;  
tb_i_b_mult_b_in = 32'd6789;  
tb_i_b_mult_start = 1;  
@(posedge tb_i_sys_clock);  
tb_i_b_mult_start = 0;  
wait(tb_o_b_mult_done == 1);  
@(posedge tb_i_sys_clock);  

// -------------------------  
// Test 3: Zero multiply (0 * 9999 = 0)  
tb_i_b_mult_a_in = 32'd0;  
tb_i_b_mult_b_in = 32'd9999;  
tb_i_b_mult_start = 1;  
@(posedge tb_i_sys_clock);  
tb_i_b_mult_start= 0;  
wait(tb_o_b_mult_done== 1);  
@(posedge tb_i_sys_clock);  

// -------------------------  
// Test 4: Multiply by one (1 * 8765 = 8765)  
tb_i_b_mult_a_in = 32'd1;  
tb_i_b_mult_b_in = 32'd8765;  
tb_i_b_mult_start = 1;  
@(posedge tb_i_sys_clock);  
tb_i_b_mult_start = 0;  
wait(tb_o_b_mult_done == 1);  
@(posedge tb_i_sys_clock);  

// -------------------------  
// Test 5: Overflow check (0xFFFFFFFF * 2)  
tb_i_b_mult_a_in = 32'hFFFFFFFF;  
tb_i_b_mult_b_in = 32'd2;  
tb_i_b_mult_start = 1;  
@(posedge tb_i_sys_clock);  
tb_i_b_mult_start = 0;  
wait(tb_o_b_mult_done == 1);  
@(posedge tb_i_sys_clock);  

// -------------------------  
// Test 6: Max * Max (0xFFFFFFFF * 0xFFFFFFFF)  
tb_i_b_mult_a_in = 32'hFFFFFFFF;  
tb_i_b_mult_b_in = 32'hFFFFFFFF;  
tb_i_b_mult_start = 1;  
@(posedge tb_i_sys_clock);  
tb_i_b_mult_start = 0;  
wait(tb_o_b_mult_done == 1);  
@(posedge tb_i_sys_clock);  

// -------------------------  
repeat(5) @(posedge tb_i_sys_clock); // Extra cycles before finish  
$finish;  
 
end 
endmodule
