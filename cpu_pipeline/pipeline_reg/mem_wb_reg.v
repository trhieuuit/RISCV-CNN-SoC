`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2026 04:51:29 PM
// Design Name: 
// Module Name: mem_wb_reg
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




module mem_wb_reg(

    input  wire        clk_i,
    input  wire        rst_ni,       // active low reset
    input  wire        flush_i,      // pipeline flush

    input  wire [31:0] pc_i,
    input  wire [4:0]  rd_i,
    input  wire [31:0] alu_i,
    input  wire [31:0] imm_i,
    input  wire [31:0] dmem_i,

    input  wire [1:0]  d_wbsel_i,
    input  wire        we_regfile_i,

    // ================= OUTPUTS =================

    output reg  [31:0] pc_o,
    output reg  [4:0]  rd_o,
    output reg  [31:0] alu_o,
    output reg  [31:0] imm_o,
    output reg  [31:0] dmem_o,

    output reg  [1:0]  d_wbsel_o,
    output reg         we_regfile_o
);

always @(posedge clk_i)
begin
    if (!rst_ni || flush_i) begin
        // RESET
        pc_o           <= 32'b0;
        rd_o           <= 5'b0;
        alu_o          <= 32'b0;
        imm_o          <= 32'b0;
        dmem_o         <= 32'b0;

        d_wbsel_o      <= 2'b0;
        we_regfile_o   <= 1'b0;
    end else begin
        // NORMAL PIPELINE TRANSFER
        pc_o           <= pc_i;
        rd_o           <= rd_i;
        alu_o          <= alu_i;
        imm_o          <= imm_i;
        dmem_o         <= dmem_i;

        d_wbsel_o      <= d_wbsel_i;
        we_regfile_o   <= we_regfile_i;
    end
end

endmodule