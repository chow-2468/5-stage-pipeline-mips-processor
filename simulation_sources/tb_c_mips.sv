`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Yu Heng, Goh Xuan Hui, Chow Bin Lin
//  
// Create Date: 07.09.2025 16:51:54
// File Name: tb_c_mips.sv 
// Module Name: tb_c_mips
// Project Name: MIPS ISA Pipeline processor
// Code Type: Behavioural 
// Description: Testbench for MIPS ISA Pipeline processor Chip
//////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////
//Please insert the hex file into "\projectName.sim\sim_1\behav\xsim\testcases"
//before running the tb
//and
//change the simulation hex file when running the tb by changing
//"$readmemh(testcaseX,mem);"
/////////////////////////////////////////////////////////////////////////////////


module tb_c_mips();

    // Inputs
    logic tb_i_c_sys_reset;
    logic tb_i_c_sys_clock;
    logic [31:0] tb_i_c_write_ins;
    logic tb_i_c_ins_wr;
    logic [6:0] i;
    
    
    // Clock and cycle definition
    parameter CC = 10; // 10ns per clock cycle
    
    // for memory write
    parameter testcase1 = "testcases/testcase1.hex";
    parameter testcase2 = "testcases/testcase2.hex";
    parameter testcase3 = "testcases/testcase3.hex";
    parameter testcase4 = "testcases/testcase4.hex";
    parameter testcase5 = "testcases/testcase5.hex";
    parameter testcase6 = "testcases/testcase6.hex";
    parameter testcase7 = "testcases/testcase7.hex";
    parameter testcase8 = "testcases/testcase8.hex";
    parameter testcase9 = "testcases/testcase9.hex";
    parameter testcase10 = "testcases/testcase10.hex";
    parameter testcase11 = "testcases/testcase11.hex";
    parameter testcase12 = "testcases/testcase12.hex";
    parameter testcase13 = "testcases/testcase13.hex";
    parameter testcase14 = "testcases/testcase14.hex";
    logic [31:0] mem[63:0]; // 64 lines instruction might enough
    
    // Instantiate DUT
    c_mips dut (
        .i_c_sys_reset(tb_i_c_sys_reset),
        .i_c_sys_clock(tb_i_c_sys_clock),
        .i_c_write_ins(tb_i_c_write_ins),
        .i_c_ins_wr(tb_i_c_ins_wr)
    );
    
    // Clock generation
    always #(CC/2) tb_i_c_sys_clock = ~tb_i_c_sys_clock;

    initial begin
        tb_i_c_sys_clock =1'b1;
        tb_i_c_sys_reset = 1;
        @(posedge tb_i_c_sys_clock); // reset the processor
        tb_i_c_sys_reset = 0;
        //----------------------------------------- 
        // Test Case X: X is the current test case number
        //-----------------------------------------
        tb_i_c_sys_reset = 1;
        @(posedge tb_i_c_sys_clock); // reset the processor
        tb_i_c_sys_reset = 0; 
        //-----------------------------------------
        //Program Mode
        //-----------------------------------------
        $readmemh(testcase4,mem);
        tb_i_c_ins_wr = 1;
        for(i=0;i<60;i++)@(posedge tb_i_c_sys_clock)
        tb_i_c_write_ins = mem[i];
        tb_i_c_ins_wr = 0;
        repeat(1)@(posedge tb_i_c_sys_clock);
        tb_i_c_sys_reset = 1;                   //reset the processor
        repeat(1)@(posedge tb_i_c_sys_clock);
        tb_i_c_sys_reset = 0;
        //-----------------------------------------
        //Normal Mode
        //-----------------------------------------
        repeat(100)@(posedge tb_i_c_sys_clock);//wait for result
        

        $finish;
    end
    
endmodule

