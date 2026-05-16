`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2026 08:27:41 PM
// Design Name: 
// Module Name: hazard_detection_unit
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
//                  Hazard Detection Unit                   //
//==========================================================//

module hazard_detection_unit (
    // ID stage data 
    input  wire [4:0] id_rs1_i, 
    input  wire [4:0] id_rs2_i,
    
    // EX stage data
    input  wire [4:0] ex_rd_i,
    input  wire       ex_is_load_i,
    input  wire       ex_branch_taken_i,
    
    // Output Stall/FLush
    output reg        stall_pc_if_id_o,
    output reg        flush_if_id_o,
    output reg        flush_id_ex_o
);


    
    // 1. Logic Stall (Only depends on Opcode and Address, available from the beginning of the cycle)
    wire load_use_hazard = ex_is_load_i && (ex_rd_i != 5'd0) && 
                          ((ex_rd_i == id_rs1_i) || (ex_rd_i == id_rs2_i));
                          
    always @(*) begin
        stall_pc_if_id_o = load_use_hazard;
    end

    // 2. Flush Logic (Only depends on the Branch flag, comes late at the end of the cycle))
    always @(*) begin
        flush_if_id_o = ex_branch_taken_i;
        
        // ID/EX is Flush when branching OR when having to inject NOP due to Stall
        flush_id_ex_o = ex_branch_taken_i | load_use_hazard; 
    end
endmodule
