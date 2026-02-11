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

module pc(
	input wire 			clk_i,
	input wire 			rst_ni,
	input wire 			branch_i,
	input wire [31:0]   jaddr_i,
	
	output reg [31:0]   pc_o
);

always @(posedge clk_i) begin
	if (!rst_ni)
		pc_o <= 0;
		
	else begin
		if (branch_i) 
			pc_o <= jaddr_i;
		else
			pc_o <= pc_o + 32'd4;
	end
end

endmodule