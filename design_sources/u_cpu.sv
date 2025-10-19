`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Jing Xuan
// Create Date: 04.09.2025 22:59:17
// File Name: u_cpu.sv
// Module Name: u_cpu
// Project Name: MIPS ISA Pipeline processor
// Code Type: RTL level 
// Description: Modeling of CPU unit block
//  
//////////////////////////////////////////////////////////////////////////////////
module u_cpu(
input logic i_sys_clock,
input logic i_sys_reset,
input logic [31:0] i_u_cpu_data,
input logic [31:0] i_u_cpu_ins,
output logic [31:0] o_u_cpu_ins_addr,
output logic [31:0] o_u_cpu_data_addr,
output logic [31:0] o_u_cpu_write_data,
output logic o_u_cpu_word,
output logic o_u_cpu_mem_wr);



//Instruction Fetch (IF) Phase
logic [31:0] instruction;
logic [31:0] IF_PC_plus4;
logic [31:0] next_PC_addr = 32'h00400000-4;
logic [31:0] instruction_addr1;
logic [31:0] instruction_addr2;


logic branch_en;
logic [31:0] branch_addr;
logic [1:0] jump;
logic [31:0] jump_addr;
logic [31:0] data1;

assign instruction = i_u_cpu_ins;
assign instruction_addr1 = branch_en ? branch_addr : (next_PC_addr+4);
assign instruction_addr2 = jump[1] ? data1 : (jump[0] ? jump_addr : instruction_addr1);
assign o_u_cpu_ins_addr = next_PC_addr;

// o_u_cpu_wr_en = i_u_cpu_ins_wr;
//assign o_u_cpu_wr_ins = i_u_cpu_write_ins;

// IF/ID pipeline
logic [31:0] IF_instruction;
always_ff @(posedge i_sys_clock)begin
    if (i_sys_reset) begin
        IF_instruction <= 32'b0;
        IF_PC_plus4 <= 32'h00400000;
        next_PC_addr <= 32'h00400000-4;
    end
    else begin
        IF_instruction <= instruction;
        next_PC_addr <= instruction_addr2;
        IF_PC_plus4 <= next_PC_addr + 4;
    end
end


// Instruction Decode (ID) Phase
logic [5:0] opcode;
logic [5:0] funct;
logic [4:0] shamt;
logic [1:0] mf;
logic pc_src;
logic ext_op;
logic mult_en;
logic alu_src;
logic [3:0] alu_ctr;
logic [1:0] reg_dst;
logic data_sel;
logic mem_wr;
logic [1:0] branch;
logic word;
logic reg_wr;
logic mem_to_reg;

assign opcode = IF_instruction [31:26];
assign funct = IF_instruction[5:0];
assign shamt = IF_instruction[10:6];


u_ctrlu control_unit( 
.i_u_ctrlu_op(opcode),
.i_u_ctrlu_funct(funct),
.o_u_ctrlu_pc_src(pc_src),
.o_u_ctrlu_mf(mf),
.o_u_ctrlu_ext_op(ext_op),
.o_u_ctrlu_jmp(jump),
.o_u_ctrlu_mult_en(mult_en),
.o_u_ctrlu_reg_dst(reg_dst),
.o_u_ctrlu_alu_src(alu_src),
.o_u_ctrlu_alu_ctr(alu_ctr),
.o_u_ctrlu_data_sel(data_sel),
.o_u_ctrlu_mem_wr(mem_wr),
.o_u_ctrlu_branch(branch),
.o_u_ctrlu_word(word),
.o_u_ctrlu_reg_wr(reg_wr),
.o_u_ctrlu_mem_to_reg(mem_to_reg));


logic [4:0] address1;
logic [4:0] address2;
logic [31:0] read_data1;
logic [31:0] read_data2;
logic [31:0] reg_hi = 32'b0;
logic [31:0] reg_lo = 32'b0;
logic [31:0] WB_wr_data;
logic [5:0] WB_wr_addr;
logic WB_reg_wr;

assign address1 = IF_instruction[25:21];
assign address2 = IF_instruction[20:16];

b_reg register_block(
.i_sys_clock(i_sys_clock),
.i_sys_reset(i_sys_reset),
.i_b_reg_read_addr1(address1),
.i_b_reg_read_addr2(address2),
.i_b_reg_wr_addr(WB_wr_addr),
.i_b_reg_wr_data(WB_wr_data),
.i_b_reg_regwr(WB_reg_wr),
.o_b_reg_read_data1(read_data1),
.o_b_reg_read_data2(read_data2));


logic [31:0] data2;
assign data2 = read_data2;
assign data1 = mf[1] ? reg_hi : (mf[0] ? reg_lo : read_data1);


logic [31:0] extended_imm;
assign extended_imm = (ext_op & IF_instruction[15]) ? {{16{IF_instruction[15]}},IF_instruction[15:0]}: {16'b0,IF_instruction[15:0]};

logic [4:0] wr_addr;
assign wr_addr = reg_dst[1] ? 5'b11111 : (reg_dst[0] ? IF_instruction[15:11] : IF_instruction[20:16]);

assign jump_addr = {IF_PC_plus4[31:20],IF_instruction[17:0],2'b00};
//assign jump_addr = {IF_PC_plus4[31:28],IF_instruction[25:0],2'b00};

// ID/EX pipeline
logic ID_mult_en;
logic ID_alu_src;
logic [3:0] ID_alu_ctr;
logic [1:0] ID_reg_dst;
logic ID_data_sel;
logic ID_mem_wr;
logic ID_word;
logic [1:0] ID_branch;
logic ID_reg_wr;
logic ID_mem_to_reg;
logic [31:0] ID_data1;
logic [31:0] ID_data2;
logic [31:0] ID_extended_imm;
logic [4:0] ID_wr_addr;
logic [4:0] ID_shamt;
logic [31:0] ID_PC_plus4;

always_ff @(posedge i_sys_clock)begin
    if (i_sys_reset) begin
        ID_mult_en <= 1'b0;
        ID_alu_src <= 1'b0;
        ID_alu_ctr <= 4'b0;
        ID_reg_dst <= 2'b0;
        ID_data_sel <= 1'b0;
        ID_mem_wr <= 1'b0;
        ID_word <= 1'b0;
        ID_branch <= 2'b0;
        ID_reg_wr <= 1'b0;
        ID_mem_to_reg <= 1'b0;
        ID_data1 <= 32'b0;
        ID_data2 <= 32'b0;
        ID_extended_imm <= 32'b0;
        ID_wr_addr <= 5'b0;
        ID_shamt <= 5'b0;
        ID_PC_plus4 <= 32'b0;
    end
    else begin
        ID_mult_en <= mult_en;
        ID_alu_src <= alu_src;
        ID_alu_ctr <= alu_ctr;
        ID_reg_dst <= reg_dst;
        ID_data_sel <= data_sel;
        ID_mem_wr <= mem_wr;
        ID_word <= word;
        ID_branch <= branch;
        ID_reg_wr <= reg_wr;
        ID_mem_to_reg <= mem_to_reg;
        ID_data1 <= data1;
        ID_data2 <= data2;
        ID_extended_imm <= extended_imm;
        ID_wr_addr <= wr_addr;
        ID_shamt <= shamt;
        ID_PC_plus4 <= IF_PC_plus4;
    end
end



// Execution (EX) Phase
logic [31:0] operand_1;
logic [31:0] operand_2;
logic [4:0] EX_shamt;
logic [3:0] EX_alu_ctr;
logic alu_branch;
logic [31:0] result;

assign operand_1 = ID_data1;
assign operand_2 = ID_alu_src ? ID_extended_imm : ID_data2;
assign EX_shamt = ID_shamt;
assign EX_alu_ctr = ID_alu_ctr;


b_alu alu_block(
.i_b_alu_operand_1(operand_1),
.i_b_alu_operand_2(operand_2),
.i_b_alu_shamt(EX_shamt),
.i_b_alu_ctrl(EX_alu_ctr),
.o_b_alu_branch(alu_branch),
.o_b_alu_result(result));

logic [31:0] alu_result;
assign alu_result = result;

logic mult_done;
logic [31:0] reg_hi_data;
logic [31:0] reg_lo_data;

b_mult multiplier_block(
.i_sys_clock(i_sys_clock),
.i_sys_reset(i_sys_reset),
.i_b_mult_start(ID_mult_en),
.i_b_mult_a_in(operand_1),
.i_b_mult_b_in(operand_2),
.o_b_mult_done(mult_done),  
.o_b_mult_hi(reg_hi_data),  
.o_b_mult_lo(reg_lo_data));



assign branch_en = (ID_branch[0] ~^ alu_branch) & ID_branch[1];
assign branch_addr = {ID_extended_imm << 2} +  ID_PC_plus4 - 4;



// EX/MEM pipeline
logic [31:0] EX_result;
logic [4:0] EX_wr_addr;
logic [31:0] EX_rt;
logic EX_data_sel;
logic EX_mem_wr;
logic EX_word;
logic EX_reg_wr;
logic EX_mem_to_reg;
logic [31:0] EX_PC_plus4;
logic EX_mult_done;
assign EX_mult_done = mult_done;

always_ff @(posedge i_sys_clock)begin
    if (i_sys_reset) begin
        EX_result <= 32'b0;
        EX_wr_addr <= 32'b0;
        EX_rt <= 32'b0;
        EX_data_sel <= 1'b0;
        EX_mem_wr <= 1'b0;
        EX_word <= 1'b0;
        EX_reg_wr <= 1'b0;
        EX_mem_to_reg <= 1'b0;
        EX_PC_plus4 <= 32'b0;
    end
    else begin
        if (EX_mult_done) begin
            reg_hi <= reg_hi_data;
            reg_lo <= reg_lo_data;
        end
    
        EX_result <= alu_result;
        EX_wr_addr <= ID_wr_addr;
        EX_rt <= ID_data2;
        EX_data_sel <= ID_data_sel;
        EX_mem_wr <= ID_mem_wr;
        EX_word <= ID_word;
        EX_reg_wr <= ID_reg_wr;
        EX_mem_to_reg <= ID_mem_to_reg;
        EX_PC_plus4 <= ID_PC_plus4;
    end
end


// Memory (MEM) Phase
logic [31:0] data;
logic [31:0] data3;
assign data = i_u_cpu_data;
assign data3 = EX_data_sel ? EX_PC_plus4 : EX_result;


// MEM/WB pipeline
logic [31:0] MEM_data2;
logic [4:0] MEM_wr_addr;
logic MEM_reg_wr;
logic MEM_mem_to_reg;


always_ff @(posedge i_sys_clock)begin
    if (i_sys_reset) begin
        o_u_cpu_data_addr <= 32'b0;
        o_u_cpu_write_data <= 32'b0;
        o_u_cpu_mem_wr <= 1'b0;
        o_u_cpu_word <= 1'b0;
        MEM_data2 <= 32'b0;
        MEM_wr_addr <= 5'b0;
        MEM_reg_wr <= 1'b0;
        MEM_mem_to_reg <= 1'b0;
    end
    else begin
        o_u_cpu_data_addr <= EX_result;
        o_u_cpu_write_data <= EX_rt;
        o_u_cpu_mem_wr <= EX_mem_wr;
        o_u_cpu_word <= EX_word;
        MEM_data2 <= data3;
        MEM_wr_addr <= EX_wr_addr;
        MEM_reg_wr <= EX_reg_wr;
        MEM_mem_to_reg <= EX_mem_to_reg;
    end
end


// Write Back (WB) Phase
logic [31:0] wr_data;
assign wr_data = MEM_mem_to_reg ? data : MEM_data2;

always_ff @(posedge i_sys_clock)begin
    if (i_sys_reset) begin
        WB_wr_data <= 32'b0;
        WB_wr_addr <= 5'b0;
        WB_reg_wr <= 1'b0;
    end
    else begin
        WB_wr_data <= wr_data;
        WB_wr_addr <= MEM_wr_addr;
        WB_reg_wr <= MEM_reg_wr;
    end
end
endmodule