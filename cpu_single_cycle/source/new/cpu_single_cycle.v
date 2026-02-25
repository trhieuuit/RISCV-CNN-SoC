`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 10:50:08 PM
// Design Name: 
// Module Name: cpu_single_cycle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_single_cycle(
    input wire clk,
    input wire reset_ni,
    
    // Cổng IMEM
    output wire [31:0] inst_addr_o,  
    input  wire [31:0] instruction, 
    
    // Cổng DMEM
    output wire [31:0] data_addr_o,    
    output wire [31:0] data_wdata_o,   
    output wire [3:0]  data_mem_ctrl_o,
    input  wire [31:0] data_rdata_i    
);

    // Dây dẫn nội bộ
    wire [31:0] pc_o, pc_plus_4, pc_next;
    wire [31:0] alu_out, imme_gen_o, wb_mux_out;
    wire [31:0] reg_file_out1, reg_file_out2, operand1, operand2;
    wire op1sel, op2sel, reg_write_en, pc_sel;
    wire [1:0] wb_sel;
    wire [2:0] imm_sel, branch_jump;
    wire [3:0] read_write;
    wire [4:0] aluop;

    // ===================================
    // 1. TẦNG FETCH
    // ===================================
    assign pc_plus_4 = pc_o + 32'd4;                   // Tính PC + 4 
    assign pc_next   = (pc_sel) ? alu_out : pc_plus_4; // Mux chọn PC nhảy hay đi thẳng

    pc program_counter (
        .clk_i(clk), 
        .rst_ni(reset_ni), 
        .pc_next(pc_next), 
        .pc_o(pc_o)
    );
    assign inst_addr_o = pc_o;

    // ===================================
    // 2. TẦNG DECODE & REGISTER
    // ===================================
    control_unit ctrl_unit(
        .opcode(instruction[6:0]), 
        .funct3(instruction[14:12]), 
        .funct7(instruction[31:25]), 
        .op1sel_out(op1sel), 
        .op2sel_out(op2sel), 
        .reg_write_en_out(reg_write_en), 
        .wb_sel_out(wb_sel), 
        .aluop_out(aluop), 
        .branch_jump_out(branch_jump), 
        .imm_sel_out(imm_sel), 
        .read_write_out(read_write)
    );

    reg_file register_file(
        .clk_i(clk), 
        .rst_ni(reset_ni), 
        .we_i(reg_write_en), 
        .raddr1_i(instruction[19:15]), // rs1
        .raddr2_i(instruction[24:20]), // rs2
        .waddr_i(instruction[11:7]),   // rd
        .wdata_i(wb_mux_out), 
        .rdata1_o(reg_file_out1), 
        .rdata2_o(reg_file_out2)
    );

    imme_gen immediate_generator (
        .in(instruction[31:7]), 
        .imm_sel(imm_sel), 
        .out(imme_gen_o)
    );


    // 3. TẦNG ALU & BRANCH

    mux_2x1_32bit operation1_mux(.in0(reg_file_out1), .in1(pc_o), .sel(op1sel), .out(operand1));
    mux_2x1_32bit operation2_mux(.in0(reg_file_out2), .in1(imme_gen_o), .sel(op2sel), .out(operand2));
    
    alu alu_unit (.operand_a_i(operand1), .operand_b_i(operand2), .alu_op_i(aluop), .alu_data_o(alu_out));
    bj_detect bj_unit(.branch_jump(branch_jump), .data1(reg_file_out1), .data2(reg_file_out2), .pc_sel_out(pc_sel));


    // 4. TẦNG DATA MEMORY -- Truyền ra ngoài

    assign data_addr_o     = alu_out;       
    assign data_wdata_o    = reg_file_out2;  
    assign data_mem_ctrl_o = read_write;     


    mux_4x1_32bit wb_mux(
        .in0(alu_out), 
        .in1(data_rdata_i), 
        .in2(imme_gen_o),   
        .in3(pc_plus_4),    
        .sel(wb_sel), 
        .out(wb_mux_out)
    );
endmodule