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
//==========================================================//
//                 ID/EX Pipeline Register                  //
//==========================================================//

module id_ex_reg(
    input wire        clk_i,
    input wire        rst_ni,
    input wire        flush_i,
    
////////////// Input ///////////////    
//IF 
    input wire [31:0] pc_i,
//ID 
    input wire [4:0]  rd_i,
    input wire [31:0] rs1_i,
    input wire [31:0] rs2_i,
    input wire [4:0]  rs1_addr_i,
    input wire [4:0]  rs2_addr_i,
    input wire [31:0] imm_i,
    input wire        is_jalr_i,
    input wire        done_i,
//EX
    input wire        d1_alusel_i,
    input wire        d2_alusel_i,
    input wire [1:0]  d1_bjsel_i,
    input wire [1:0]  d2_bjsel_i,
    input wire [4:0]  op_alu_i,
    input wire [2:0]  bju_op_i,
//MEM
    input wire        is_load_i,
    input wire        dmem_we_i,
    input wire [3:0]  rw_dmem_i,
//WB
    input wire [1:0]  wb_sel_i,
    input wire        reg_we_i,
    
////////////// Output ///////////////
//IF      
    output reg [31:0] pc_o,
//ID 
    output reg [4:0]  rd_o,
    output reg [31:0] rs1_o,
    output reg [31:0] rs2_o,
    output reg [4:0]  rs1_addr_o,
    output reg [4:0]  rs2_addr_o,
    output reg [31:0] imm_o,
    output reg        is_jalr_o,
    output reg        done_o,
//EX
    output reg [1:0]  d1_alusel_o,
    output reg [1:0]  d2_alusel_o,
    output reg [1:0]  d1_bjsel_o,
    output reg [1:0]  d2_bjsel_o,
    output reg [4:0]  op_alu_o,
    output reg [2:0]  bju_op_o,
//MEM   
    output reg        is_load_o,
    output reg        dmem_we_o,
    output reg [3:0]  rw_dmem_o,
//WB
    output reg [1:0]  wb_sel_o,
    output reg        reg_we_o
);
    
always @(posedge clk_i) begin
    if (!rst_ni) begin
        pc_o          <= 32'b0;
        rd_o          <= 5'b0;
        rs1_o         <= 32'b0;
        rs2_o         <= 32'b0;
        rs1_addr_o    <= 5'b0;
        rs2_addr_o    <= 5'b0;
        imm_o         <= 32'b0;
        d1_alusel_o   <= 1'b0;
        d2_alusel_o   <= 1'b0;
        d1_bjsel_o    <= 2'b0;
        d2_bjsel_o    <= 2'b0;
        op_alu_o      <= 5'b0;
        bju_op_o       <= 3'b010;
        is_jalr_o     <= 1'b0;
        is_load_o   <= 1'b0;
        dmem_we_o     <= 1'b0;
        rw_dmem_o     <= 4'b0;
        wb_sel_o     <= 2'b0;
        reg_we_o  <= 1'b0;
        done_o  <= 1'b0;
        
    end else if (flush_i) begin
        reg_we_o  <= 1'b0;
        dmem_we_o     <= 1'b0;
        is_load_o   <= 1'b0;
        bju_op_o       <= 3'b010; 
        is_jalr_o     <= 1'b0;
        done_o  <= 1'b0;
        
        pc_o          <= pc_i;
        rd_o          <= rd_i;
        rs1_o         <= rs1_i;
        rs2_o         <= rs2_i;
        rs1_addr_o    <= rs1_addr_i;
        rs2_addr_o    <= rs2_addr_i;
        imm_o         <= imm_i;
        d1_alusel_o   <= d1_alusel_i;
        d2_alusel_o   <= d2_alusel_i;
        d1_bjsel_o    <= d1_bjsel_i;
        d2_bjsel_o    <= d2_bjsel_i;
        op_alu_o      <= op_alu_i;
        rw_dmem_o     <= rw_dmem_i;
        wb_sel_o     <= wb_sel_i;   
    end else begin
        pc_o          <= pc_i;
        rd_o          <= rd_i;
        rs1_o         <= rs1_i;
        rs2_o         <= rs2_i;
        rs1_addr_o    <= rs1_addr_i;
        rs2_addr_o    <= rs2_addr_i;
        imm_o         <= imm_i;
        d1_alusel_o   <= d1_alusel_i;
        d2_alusel_o   <= d2_alusel_i;
        d1_bjsel_o    <= d1_bjsel_i;
        d2_bjsel_o    <= d2_bjsel_i;
        op_alu_o      <= op_alu_i;
        bju_op_o       <= bju_op_i;
        is_jalr_o     <= is_jalr_i;
        is_load_o   <= is_load_i;
        dmem_we_o     <= dmem_we_i;
        rw_dmem_o     <= rw_dmem_i;
        wb_sel_o     <= wb_sel_i;
        reg_we_o  <= reg_we_i;
        done_o  <= done_i;
    end
end

endmodule