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

    always @(*) begin
        // Default cases
        stall_pc_if_id_o = 1'b0;
        flush_if_id_o    = 1'b0;
        flush_id_ex_o    = 1'b0;

        // Branch prioritized
        if (ex_branch_taken_i) begin
            flush_if_id_o = 1'b1;     //Flush in IF/ID 
            flush_id_ex_o = 1'b1;     //Flush in ID/EX 
        end
        
        // Load-use Hazard lower priority
        else if (ex_is_load_i && (ex_rd_i != 5'd0) && ((ex_rd_i == id_rs1_i) || (ex_rd_i == id_rs2_i))) begin
            stall_pc_if_id_o = 1'b1;   //Stall in IF/ID
            flush_id_ex_o    = 1'b1;   //NOP in ID/EX
        end
    end
endmodule
