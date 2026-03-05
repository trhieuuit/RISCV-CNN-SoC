`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2026 05:24:13 PM
// Design Name: 
// Module Name: if_id_wrapper
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


module if_id_wrapper(
    input wire 			clk_i,
	input wire 			rst_ni,
	input wire 			branch_i,
	input wire [31:0]   jaddr_i,
	input wire          stall_i,
	  
	output wire [31:0] pc_o,
    output wire [31:0] imem_o
    );
    
    wire [31:0] pc_reg;
    pc pc (
        .clk_i (clk_i),
	    .rst_ni (rst_ni),
	    .branch_i (branch_i),
	    .jaddr_i (jaddr_i),
	    .stall_i (stall_i),
	    .pc_o ( pc_reg)
	 );
	 
	 if_id_reg u (
	    .clk_i (clk_i),
        .rst_ni (rst_ni),
        .stall_i (stall_i),
        .pc_i (pc_reg),
        .pc_o (pc_o),
        .instr_o (imem_o)
     );
     
     
	  
endmodule
