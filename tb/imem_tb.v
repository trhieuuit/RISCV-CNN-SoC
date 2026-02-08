`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2026 05:24:08 PM
// Design Name: 
// Module Name: imem_tb
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


`timescale 1ns / 1ps

module imem_tb;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter NUM_INS    = 1000;

    // Inputs
    reg clk_i;
    reg rst_i;
    reg [31:0] addr_i;

    // Output
    wire [31:0] imem_o;

    // Instantiate DUT
    imem #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_INS(NUM_INS)
    ) uut (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .addr_i(addr_i),
        .imem_o(imem_o)
    );

    // Clock generation (10ns period)
    always #5 clk_i = ~clk_i;

    initial begin
        // Initialize signals
        clk_i  = 0;
        rst_i  = 0;
        addr_i = 0;

        // Wait a little
        #10;

        // Read first instruction (address 0)
        addr_i = 32'd0;
        #10;

        // Read second instruction (address 4)
        addr_i = 32'd4;
        #10;

        // Read third instruction (address 8)
        addr_i = 32'd8;
        #10;

        // Random read
        addr_i = 32'd12;
        #10;

        $stop;
    end

endmodule
