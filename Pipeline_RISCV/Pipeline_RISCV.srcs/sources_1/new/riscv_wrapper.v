`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2026 01:07:49 AM
// Design Name: 
// Module Name: riscv_wrapper
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


module riscv_wrapper (
    input  wire        clk_i,
    input  wire        rst_ni,

    // --- KÊNH ĐIỀU KHIỂN ---
    input  wire        rv_start_i, 
    output wire        rv_done_o,  

    // --- KÊNH IMEM (Chỉ thò chân ra để nối vào Port B của BRAM IP) ---
    output wire [31:0] imem_addr_o,
    output wire        imem_en_o,
    input  wire [31:0] imem_rdata_i,

    // --- KÊNH DMEM (Thò chân ra để nối vào Port B của BRAM IP) ---
    output wire [31:0] dmem_addr_o,
    output wire [31:0] dmem_wdata_o,
    input  wire [31:0] dmem_rdata_i,
    output wire [3:0]  dmem_we_o,
    output wire        dmem_en_o
);

    // Reset lõi
    wire core_reset_n = rst_ni & rv_start_i;

    cpu_pipeline rv_core (
        .clk           (clk_i),
        .reset_ni      (core_reset_n),
        
        // Kênh Instruction Memory
        .inst_en_o     (imem_en_o),
        .inst_addr_o   (imem_addr_o),
        .instruction   (imem_rdata_i),
        
        // Kênh Data Memory
        .data_en_o     (dmem_en_o),
        .data_addr_o   (dmem_addr_o),
        .data_wdata_o  (dmem_wdata_o),
        .data_rdata_i  (dmem_rdata_i),
        .data_we_o     (dmem_we_o),
        
        .rv_done_o (rv_done_o)
    );

endmodule