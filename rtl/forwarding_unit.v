`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2026 06:06:11 PM
// Design Name: 
// Module Name: forwarding_unit
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
`include "encoding.v"

module forwarding_unit(
    //////////// INPUT ////////////
    // Execute
    input wire [4:0]    ex_rs1_addr,
    input wire [4:0]    ex_rs2_addr,
    input wire [31:0]   ex_rs1_data,
    input wire [31:0]   ex_rs2_data,
    input wire [6:0]    ex_opcode,
    // Memory
    input wire [4:0]    mem_rd_addr,
    input wire [31:0]   mem_rd_data,
    input wire [6:0]    mem_opcode,
    // Write back
    input wire [4:0]    wb_rd_addr,
    input wire [31:0]   wb_rd_data,
    input wire [6:0]    wb_opcode,
    
    //////////// OUTPUT ////////////
    // Execute
    output reg [31:0]  ex_data1,
    output reg [31:0]  ex_data2
    );
    
    wire mem_write = (mem_opcode == `LUI_OPCODE  || mem_opcode == `AUIPC_OPCODE || mem_opcode == `JAL_OPCODE 
               || mem_opcode == `JALR_OPCODE || mem_opcode == `LOAD_OPCODE  || mem_opcode == `I_TYPE_OPCODE 
               || mem_opcode == `R_TYPE_OPCODE) && (mem_rd_addr != 5'b0) ;

    wire wb_write  = (wb_opcode  == `LUI_OPCODE  || wb_opcode  == `AUIPC_OPCODE || wb_opcode  == `JAL_OPCODE 
               || wb_opcode  == `JALR_OPCODE || wb_opcode  == `LOAD_OPCODE  || wb_opcode  == `I_TYPE_OPCODE 
               || wb_opcode  == `R_TYPE_OPCODE) && (wb_rd_addr != 5'b0);                   
    
    
    // ex_data1
    always @(*) begin
        // Mem priortitized
        if (mem_write && (ex_rs1_addr == mem_rd_addr))
            ex_data1 = mem_rd_data;
        else if (wb_write && (ex_rs1_addr == wb_rd_addr))
            ex_data1 = wb_rd_data;
        else
            ex_data1 = ex_rs1_data;
    end  
    
   // ex_data2
    always @(*) begin
        // Mem priortitized
        if (mem_write && (ex_rs2_addr == mem_rd_addr))
            ex_data2 = mem_rd_data;
        // WB is lower 
        else if (wb_write && (ex_rs2_addr == wb_rd_addr))
            ex_data2 = wb_rd_data;
        else
            ex_data2 = ex_rs2_data;
    end
            
endmodule
