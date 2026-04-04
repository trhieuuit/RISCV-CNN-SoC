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
//==========================================================//
//                    Forwarding Unit                       //
//==========================================================//

module forwarding_unit(
    // EX stage address
    input wire [4:0]    ex_rs1_addr_i,
    input wire [4:0]    ex_rs2_addr_i,
    
    // MEM stage data
    input wire [4:0]    mem_rd_addr_i,
    input wire          mem_write_i,
    
    // WB stage data
    input wire [4:0]    wb_rd_addr_i,
    input wire          wb_write_i,
    
    // Forwarding MUX selection
    output reg  [1:0]   ex_rs1_sel_o,
    output reg  [1:0]   ex_rs2_sel_o
);
    
//==========================================================//
//                 Forwarding RS1 Data                      //
//==========================================================//
    always @(*) begin
        // Mem priortitized
        if (mem_write_i && (ex_rs1_addr_i == mem_rd_addr_i) && (mem_rd_addr_i != 5'b0))
            ex_rs1_sel_o = `RS1_EX_MEM;
        // WB lower priority   
        else if (wb_write_i && (ex_rs1_addr_i == wb_rd_addr_i) && (wb_rd_addr_i != 5'b0))
            ex_rs1_sel_o = `RS1_MEM_WB;
        else
            ex_rs1_sel_o = `RS1_ID_EX;
    end  
    
    
//==========================================================//
//                 Forwarding RS2 Data                      //
//==========================================================//
    always @(*) begin
        // Mem priortitized
        if (mem_write_i && (ex_rs2_addr_i == mem_rd_addr_i) && (mem_rd_addr_i != 5'b0))
            ex_rs2_sel_o = `RS2_EX_MEM;
        // WB lower priority   
        else if (wb_write_i && (ex_rs2_addr_i == wb_rd_addr_i) && (wb_rd_addr_i != 5'b0))
            ex_rs2_sel_o = `RS2_MEM_WB;
        else
            ex_rs2_sel_o = `RS2_ID_EX;
    end
            
endmodule
