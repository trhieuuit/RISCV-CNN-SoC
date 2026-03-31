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
//`include "encoding.v"

module forwarding_unit(
    //////////// INPUT ////////////
    // Execute
    input wire [4:0]    ex_rs1_addr,
    input wire [4:0]    ex_rs2_addr,
    // Memory
    input wire [4:0]    mem_rd_addr,
    input wire          mem_write,
    // Write back
    input wire [4:0]    wb_rd_addr,
    input wire          wb_write,
    
    //////////// OUTPUT ////////////
    // Execute
    output reg  [1:0]   ex_rs1_sel,
    output reg  [1:0]   ex_rs2_sel
    );
    
    
    // ex_data1
    always @(*) begin
        // Mem priortitized
        if (mem_write && (ex_rs1_addr == mem_rd_addr) && (mem_rd_addr != 5'b0))
            ex_rs1_sel = `RS1_EX_MEM;
        else if (wb_write && (ex_rs1_addr == wb_rd_addr) && (wb_rd_addr != 5'b0))
            ex_rs1_sel = `RS1_MEM_WB;
        else
            ex_rs1_sel = `RS1_ID_EX;
    end  
    
   // ex_data2
    always @(*) begin
        // Mem priortitized
        if (mem_write && (ex_rs2_addr == mem_rd_addr) && (mem_rd_addr != 5'b0))
            ex_rs2_sel = `RS2_EX_MEM;
        // WB is lower 
        else if (wb_write && (ex_rs2_addr == wb_rd_addr) && (wb_rd_addr != 5'b0))
            ex_rs2_sel = `RS2_MEM_WB;
        else
            ex_rs2_sel = `RS2_ID_EX;
    end
            
endmodule
