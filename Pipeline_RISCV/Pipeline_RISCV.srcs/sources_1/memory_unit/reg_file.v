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


//==========================================================//
//                    Register File                         //
//==========================================================//

module reg_file #(
	parameter DATA_WIDTH = 32,
	parameter NUM_REGS	= 32,
	parameter ADDR_WIDTH = $clog2(NUM_REGS)
	)(
		input clk_i,
		input rst_ni,	
		input we_i,	//Write Enable 
		
		input [ADDR_WIDTH-1:0] raddr1_i,
		input [ADDR_WIDTH-1:0] raddr2_i,
		input [ADDR_WIDTH-1:0] waddr_i,
		input [DATA_WIDTH-1:0] wdata_i,
		
		output [DATA_WIDTH-1:0] rdata1_o,
		output [DATA_WIDTH-1:0] rdata2_o
    );
		
		
// Register declaration	
	reg [DATA_WIDTH-1:0] registers_r [0:NUM_REGS-1];
		
// Set the initial value of every registers to 0
    integer i;
    initial begin
       for (i = 0; i < NUM_REGS; i = i + 1) registers_r[i] = 32'b0;
    end
    
//==========================================================//
//                   RS1/RS2 Read Port                      //
//==========================================================//
// Same cycle Read after Write (RAW) data hazard handled here
	assign rdata1_o = (raddr1_i == 5'b0) ? 32'b0 : 
                  (we_i && (waddr_i == raddr1_i)) ? wdata_i : 
                  registers_r[raddr1_i];

    assign rdata2_o = (raddr2_i == 5'b0) ? 32'b0 : 
                  (we_i && (waddr_i == raddr2_i)) ? wdata_i : 
                  registers_r[raddr2_i];
                  
//==========================================================//
//                     Write Port                           //
//==========================================================//
		always @(posedge clk_i) begin
			if(!rst_ni) begin 
				for (i=0; i<32; i = i + 1)	 begin 
					registers_r[i] <= 32'b0;
				end 
			end
			
			else if (we_i && (waddr_i != 0)) begin 
				registers_r[waddr_i] <= wdata_i;
			end
		end
endmodule
