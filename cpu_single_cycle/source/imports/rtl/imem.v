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
	input wire 		   rst_ni,
	input wire [31:0]  addr_i,  
	
	output wire [31:0]  imem_o
);

    reg [DATA_WIDTH-1:0] rom[0:NUM_INS-1];

	initial begin
		$readmemb("D:/Hoc_Tap/Dai_hoc/HK6/DoAn1/RISCV/RISCV.srcs/sources_1/new/machine_code.mem", rom);
	end
	
	
     assign   imem_o = rom[addr_i[31:2]];
    

endmodule