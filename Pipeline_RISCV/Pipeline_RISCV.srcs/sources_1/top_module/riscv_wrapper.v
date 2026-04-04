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
//==========================================================//
//                    RISC-V Wrapper                        //
//==========================================================//
///////////// This is used for Vivado Block Design ///////////

module riscv_wrapper (
    input  wire        clk_i,
    input  wire        rst_ni,

    // Start/Done signals
    input  wire        rv_start_i, 
    output wire        rv_done_o,  
    
    //IMEM Ports
    input  wire [31:0] imem_rdata_i,
    output wire [31:0] imem_addr_o,
    output wire        imem_en_o,
   
    //DMEM Ports
    input  wire [31:0] dmem_rdata_i,
    output wire [31:0] dmem_addr_o,
    output wire [31:0] dmem_wdata_o,
    output wire [3:0]  dmem_we_o,
    output wire        dmem_en_o
);

    // Reset when either Start signal or global reset goes to 0
    wire comb_rst_w = rst_ni & rv_start_i;
    
    // Register the reset signal to prevent combinational glitches
    reg core_rst_n_r;
    always @(posedge clk_i) begin
        core_rst_n_r <= comb_rst_w;
    end

    cpu_pipeline rv_core (
        .clk_i         (clk_i),
        .reset_ni      (core_rst_n_r),
        .instr_en_o    (imem_en_o),
        .instr_addr_o  (imem_addr_o),
        .instr_i       (imem_rdata_i),
        .data_en_o     (dmem_en_o),
        .data_addr_o   (dmem_addr_o),
        .data_wdata_o  (dmem_wdata_o),
        .data_rdata_i  (dmem_rdata_i),
        .data_we_o     (dmem_we_o),
        .done_o        (rv_done_o)
    );

endmodule