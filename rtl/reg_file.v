`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2026 07:45:18 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file #(
	parameter DATA_WIDTH = 32,
	parameter NUM_REGS	= 32,
	parameter ADDR_WIDTH = $clog2(NUM_REGS)
	)(
		input clk_i,
		input rst_ni,	//Active Low Reset 
		input we_i,	//Write Enable 
		
		input [ADDR_WIDTH-1:0] raddr1_i,
		input [ADDR_WIDTH-1:0] raddr2_i,
		input [ADDR_WIDTH-1:0] waddr_i,
		input [DATA_WIDTH-1:0] wdata_i,
		
		output [DATA_WIDTH-1:0] rdata1_o,
		output [DATA_WIDTH-1:0] rdata2_o
		);
		
		reg [DATA_WIDTH-1:0] registers [0:NUM_REGS-1];
		integer i;
		
		//Output 
		// Refined Output Logic (Internal Forwarding / Transparency)
        assign rdata1_o = (raddr1_i == 5'b0) ? 32'b0 : 
                          ((we_i && (waddr_i == raddr1_i)) ? wdata_i : registers[raddr1_i]);
        
        assign rdata2_o = (raddr2_i == 5'b0) ? 32'b0 : 
                          ((we_i && (waddr_i == raddr2_i)) ? wdata_i : registers[raddr2_i]);
	
		//Input
		always @(posedge clk_i) begin
			if(!rst_ni) begin 
				for (i=0; i<32; i = i + 1)	 begin 
					registers[i] <= 32'b0;
				end 
			end
			
			else if (we_i && (waddr_i != 0)) begin 
				registers[waddr_i] <= wdata_i;
			end
		end
		
		
endmodule
