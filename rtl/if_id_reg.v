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


module if_id_reg(
    input wire         clk_i,
    input wire         rst_ni,
    input wire         stall_i,
    input wire         flush_i,
    input wire  [31:0] pc_i,
    
    output reg [31:0]  pc_o

    );
    
 
     always @(posedge clk_i) begin
        if (!rst_ni || flush_i) begin
            pc_o <= 32'b0;
        end else if (!stall_i) begin
            pc_o <= pc_i;
        end
    end
    
    
endmodule
