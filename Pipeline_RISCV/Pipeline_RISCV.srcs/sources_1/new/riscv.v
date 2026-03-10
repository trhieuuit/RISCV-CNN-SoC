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


module riscv(
    input wire clk,
    input wire reset_ni
    );
    
    // ===========================================================================
    // DÂY KẾT NỐI GIỮA CPU VÀ BỘ NHỚ LỆNH (IMEM)
    // ===========================================================================
    wire [31:0] inst_addr;
    wire        inst_en;
    wire [31:0] instruction;

    // ===========================================================================
    // DÂY KẾT NỐI GIỮA CPU VÀ BỘ NHỚ DỮ LIỆU (DMEM)
    // ===========================================================================
    wire [31:0] data_addr;
    wire [31:0] data_wdata;
    wire        data_en;
    wire [3:0]  data_we;
    wire [31:0] data_rdata;

    // ===========================================================================
    // 1. TRÁI TIM HỆ THỐNG: LÕI CPU PIPELINE 5 TẦNG
    // ===========================================================================
    cpu_pipeline rv_core (
        .clk             (clk),
        .reset_ni        (reset_ni),
        
        // Giao tiếp IMEM
        .inst_addr_o     (inst_addr),
        .inst_en_o       (inst_en),
        .instruction     (instruction),
        
        // Giao tiếp DMEM
        .data_addr_o     (data_addr),
        .data_wdata_o    (data_wdata),
        .data_en_o       (data_en),
        .data_we_o       (data_we),
        .data_rdata_i    (data_rdata)
    );

    // ===========================================================================
    // 2. BỘ NHỚ LỆNH (INSTRUCTION MEMORY - BRAM)
    // ===========================================================================
    // Dung lượng: 1000 lệnh (Tùy chỉnh tham số NUM_INS nếu file .mem của bạn lớn hơn)
    imem #(
        .DATA_WIDTH(32),
        .NUM_INS(1000)
    ) instruction_memory (
        .clk_i           (clk),
        .rst_ni          (reset_ni),
        .en_i            (inst_en),
        .addr_i          (inst_addr),
        
        .imem_o          (instruction)
    );

    // ===========================================================================
    // 3. BỘ NHỚ DỮ LIỆU (DATA MEMORY - BRAM)
    // ===========================================================================
    // Dung lượng: 2048 words (8KB)
    dmem #(
        .DATA_WIDTH(32),
        .NUM_WORDS(2048)
    ) data_memory (
        .clk_i           (clk),
        .en_i            (data_en),
        .we_i            (data_we),
        .addr_i          (data_addr),
        .data_i          (data_wdata),
        
        .mem_o           (data_rdata)
    );
endmodule
