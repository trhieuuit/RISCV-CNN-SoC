`timescale 1ns / 1ps
//==========================================================//
//                MEM/WB Pipeline Register                  //
//==========================================================//

module mem_wb_reg(

    input  wire        clk_i,
    input  wire        rst_ni,       
    
////////////// Input ///////////////     
//IF
    input  wire [31:0] pc_i,
//ID
    input  wire [4:0]  rd_i,
    input  wire [31:0] imm_i,
//EX   
    input  wire [31:0] alu_i,
//MEM
    input  wire [3:0]  rw_dmem_i,
//WB
    input  wire [1:0]  wb_sel_i,
    input  wire        reg_we_i,
    
////////////// Output /////////////// 
//IF    
    output reg  [31:0] pc_o,
//ID  
    output reg  [4:0]  rd_o,
    output reg  [31:0] imm_o,
//EX    
    output reg  [31:0] alu_o,
//MEM   
    output reg  [3:0]  rw_dmem_o,
//WB    
    output reg  [1:0]  wb_sel_o,
    output reg         reg_we_o
);

always @(posedge clk_i)
begin
    if (!rst_ni) begin
        pc_o           <= 32'b0;
        rd_o           <= 5'b0;
        alu_o          <= 32'b0;
        imm_o          <= 32'b0;
        wb_sel_o      <= 2'b0;
        reg_we_o   <= 1'b0;
        rw_dmem_o      <= 4'b0;
    end else begin
        pc_o           <= pc_i;
        rd_o           <= rd_i;
        alu_o          <= alu_i;
        imm_o          <= imm_i;
        wb_sel_o      <= wb_sel_i;
        reg_we_o   <= reg_we_i;
        rw_dmem_o      <= rw_dmem_i;
    end
end
endmodule