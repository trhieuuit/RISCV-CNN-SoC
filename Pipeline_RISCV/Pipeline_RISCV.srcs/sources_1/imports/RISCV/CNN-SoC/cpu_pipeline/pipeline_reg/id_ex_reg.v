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


module id_ex_reg(
    input wire        clk_i,
    input wire        rst_ni,
    input wire        flush_i,
    input wire [31:0] pc_i,
    input wire [4:0]  rd_i,
    input wire [31:0] rs1_i,
    input wire [31:0] rs2_i,
    
    input wire [4:0]  rs1_addr_i,
    input wire [4:0]  rs2_addr_i,
    
    
    input wire [31:0] imm_i,
    input wire  d1_alusel_i,
    input wire  d2_alusel_i,
    input wire [1:0]  d1_bjsel_i,
    input wire [1:0]  d2_bjsel_i,
    input wire [4:0]  op_alu_i,
    input wire [2:0]  op_bl_i,
    input wire        d_dmemsel_i,
    input wire        we_dmem_i,
    input wire [3:0]  rw_dmem_i,
    input wire [1:0]  d_wbsel_i,
    input wire        we_regfile_i,
    
    output reg  [31:0] pc_o,
    output reg  [4:0]  rd_o,
    output reg  [31:0] rs1_o,
    output reg  [31:0] rs2_o,
    
    output reg [4:0]  rs1_addr_o,
    output reg [4:0]  rs2_addr_o,
    
    output reg  [31:0] imm_o,

    output reg  [1:0]  d1_alusel_o,
    output reg  [1:0]  d2_alusel_o,
    output reg  [1:0]  d1_bjsel_o,
    output reg  [1:0]  d2_bjsel_o,

    output reg  [4:0]  op_alu_o,
    output reg  [2:0]  op_bl_o,

    output reg         d_dmemsel_o,
    output reg         we_dmem_o,
    output reg  [3:0]  rw_dmem_o,

    output reg  [1:0]  d_wbsel_o,
    output reg         we_regfile_o
    );
    
always @(posedge clk_i)
begin
    if (!rst_ni || flush_i) begin
        pc_o          <= 32'b0;
        rd_o          <= 5'b0;
        rs1_o         <= 32'b0;
        rs2_o         <= 32'b0;
        
        rs1_addr_o <= 5'b0;
        rs2_addr_o <= 5'b0;
    
    
        imm_o         <= 32'b0;

        d1_alusel_o   <= 1'b0;
        d2_alusel_o   <= 1'b0;
        d1_bjsel_o    <= 2'b0;
        d2_bjsel_o    <= 2'b0;

        op_alu_o      <= 5'b0;
        op_bl_o       <= 3'b010;

        d_dmemsel_o   <= 1'b0;
        we_dmem_o     <= 1'b0;
        rw_dmem_o     <= 4'b0;

        d_wbsel_o     <= 2'b0;
        we_regfile_o  <= 1'b0;
    end else begin
        pc_o          <= pc_i;
        rd_o          <= rd_i;
        rs1_o         <= rs1_i;
        rs2_o         <= rs2_i;
        
        rs1_addr_o <= rs1_addr_i;
        rs2_addr_o <= rs2_addr_i;
    
        imm_o         <= imm_i;

        d1_alusel_o   <= d1_alusel_i;
        d2_alusel_o   <= d2_alusel_i;
        d1_bjsel_o    <= d1_bjsel_i;
        d2_bjsel_o    <= d2_bjsel_i;

        op_alu_o      <= op_alu_i;
        op_bl_o       <= op_bl_i;

        d_dmemsel_o   <= d_dmemsel_i;
        we_dmem_o     <= we_dmem_i;
        rw_dmem_o     <= rw_dmem_i;

        d_wbsel_o     <= d_wbsel_i;
        we_regfile_o  <= we_regfile_i;
    end
end

endmodule