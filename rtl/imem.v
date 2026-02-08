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


module imem#(
	parameter DATA_WIDTH = 32,
	parameter NUM_INS = 1000
	)(
	input wire 		   clk_i,
	input wire 		   rst_i,
	input wire [31:0]  addr_i,  
	
	output reg [31:0]  imem_o
);

    reg [DATA_WIDTH-1:0] rom[0:NUM_INS-1];

	initial begin
		$readmemb("machine_code.mem", rom);
	end
	
	always @(posedge clk_i) begin
        imem_o <= rom[addr_i[31:2]];
    end

endmodule