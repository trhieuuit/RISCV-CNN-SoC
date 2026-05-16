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
//                IF/ID Pipeline Register                   //
//==========================================================//

module if_id_reg(
    input wire         clk_i,
    input wire         rst_ni,
    input wire         stall_i,
    input wire         flush_i,
    
////////////// Input ///////////////
    input wire  [31:0] pc_i,
    
////////////// Output ///////////////
    output reg [31:0]  pc_o
);
    

    
    always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        pc_o <= 32'b0; // Only erase PC when there is a Hard Reset
    end
    else if (stall_i) begin
        pc_o <= pc_o;  // Retains value when Stalled
    end
    else begin
        pc_o <= pc_i;  // Whether there is FLUSH OR NOT, the PC still flows normally
    end
end


endmodule
