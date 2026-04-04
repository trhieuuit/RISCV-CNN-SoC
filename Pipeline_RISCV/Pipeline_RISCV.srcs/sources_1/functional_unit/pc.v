`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: DMEM
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
//                   Program Counter                        //
//==========================================================//	

module pc(
    input  wire        clk_i,
    input  wire        rst_ni,
    input  wire        stall_i,   
    input  wire [31:0] pc_next_i, 
    output reg  [31:0] pc_o
);


// Load pc_next into pc_o
// pc_next is calculted in cpu_pipeline.v
    always @(posedge clk_i or negedge rst_ni ) begin
        if (!rst_ni) 
            pc_o <= 32'h0;
        else if (!stall_i)        
            pc_o <= pc_next_i;
    end
endmodule