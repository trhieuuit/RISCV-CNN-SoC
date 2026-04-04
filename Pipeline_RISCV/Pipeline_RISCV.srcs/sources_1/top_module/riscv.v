`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2026 10:47:20 AM
// Design Name: 
// Module Name: riscv
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
//==========================================================//
//                      RISC-V Full                         //
//==========================================================//
// This module implements a fully functional RISC-V core

module riscv(
    input  wire clk_i,
    input  wire reset_ni,
    output wire rv_done_o 
);

//==========================================================//
//                   Wire Declaration                       //
//==========================================================//
    wire [31:0] inst_addr_w;
    wire        inst_en_w;
    wire [31:0] instr_w;
    wire [31:0] data_addr_w;
    wire [31:0] data_wdata_w;
    wire        data_en_w;
    wire [3:0]  data_we_w;
    wire [31:0] data_rdata_w;

//==========================================================//
//                RISC-V Main Components                    //
//==========================================================//
    cpu_pipeline rv_core (
        .clk_i           (clk_i),
        .reset_ni        (reset_ni),
        .instr_addr_o    (inst_addr_w),
        .instr_en_o      (inst_en_w),
        .instr_i         (instr_w),
        .data_addr_o     (data_addr_w),
        .data_wdata_o    (data_wdata_w),
        .data_en_o       (data_en_w),
        .data_we_o       (data_we_w),
        .data_rdata_i    (data_rdata_w),
        .done_o          (rv_done_o)
    );

//==========================================================//
//                  Instruction Memory                      //
//==========================================================//
    imem #(
        .DATA_WIDTH(32),
        .NUM_INS(1000)
    ) instruction_memory (
        .clk_i           (clk_i),
        .rst_ni          (reset_ni),
        .en_i            (inst_en_w),
        .addr_i          (inst_addr_w),
        .imem_o          (instr_w)
    );

//==========================================================//
//                     Data Memory                          //
//==========================================================//
    dmem #(
        .DATA_WIDTH(32),
        .NUM_WORDS(2048)
    ) data_memory (
        .clk_i           (clk_i),
        .en_i            (data_en_w),
        .we_i            (data_we_w),
        .addr_i          (data_addr_w),
        .data_i          (data_wdata_w),
        .mem_o           (data_rdata_w)
    );

endmodule
