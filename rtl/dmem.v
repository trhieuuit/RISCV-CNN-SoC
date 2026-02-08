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


module dmem#(
	parameter DATA_WIDTH = 32,
	parameter NUM_VAR	= 32,
	parameter ADDR_WIDTH = $clog2(NUM_VAR)
	)(
    input wire                      clk_i,
    input wire                      rst_ni,
    input wire [ADDR_WIDTH - 1:0]   addr_i,    // can thay doi
    input wire [31:0]               data_i,
    input wire                      we_i,
    
    output reg [31:0]               mem_o
);

    
    
    reg [DATA_WIDTH - 1:0] registers [NUM_VAR - 1 :0];
    
    integer i;

    always @(posedge clk_i) begin
        if (!rst_ni) begin
            for (i = 0; i < NUM_VAR; i = i + 1)
                registers[i] <= 32'd0;
            mem_o <= 32'd0;
          end
            
         else begin
            if (we_i) begin
                registers[addr_i] <= data_i;
            end

            mem_o <= registers[addr_i];

        end
    end
endmodule

