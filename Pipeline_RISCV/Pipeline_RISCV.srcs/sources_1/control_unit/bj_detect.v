`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2026 10:32:06 PM
// Design Name: 
// Module Name: bj_detect
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



module bj_detect(
    input  wire [2:0]  branch_jump_i,
    input  wire [31:0] data1_i,
    input  wire [31:0] data2_i,
    output reg         pc_sel_o
);

//==========================================================//
//                   Branch Detection                       //
//==========================================================//	
    // Comparison flag calculation
    wire eq_w          = (data1_i == data2_i);
    wire unsigned_lt_w = (data1_i < data2_i);
    wire signed_lt_w   = ($signed(data1_i) < $signed(data2_i));

	
    // Output the signal to control PC's MUX (whether to jump or increase by 4)
    always @(*) begin
        pc_sel_o = 1'b0; 
        case (branch_jump_i)
           `BEQ: if (eq_w)          pc_sel_o = 1'b1; // (BEQ)
           `BNE: if (!eq_w)         pc_sel_o = 1'b1; // (BNE)
           `J:                      pc_sel_o = 1'b1; // (JAL/JALR)
            
            // "Less than" instructions
            `BLT: if (signed_lt_w)      pc_sel_o = 1'b1; // (BLT)
            `BLTU: if (unsigned_lt_w)   pc_sel_o = 1'b1; // (BLTU)
            
           // "Greater than" and "equal" instructions
           `BGE: if (!signed_lt_w)      pc_sel_o = 1'b1; // (BGE)
            `BGEU: if (!unsigned_lt_w)  pc_sel_o = 1'b1; // (BGEU)
            
            default: pc_sel_o = 1'b0;
        endcase
    end


endmodule
