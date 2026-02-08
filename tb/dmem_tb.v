`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2026 05:35:32 PM
// Design Name: 
// Module Name: dmem_tb
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


module dmem_tb;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter NUM_VAR   = 32;
    parameter ADDR_WIDTH = $clog2(NUM_VAR);

    // Inputs
    reg clk_i;
    reg rst_ni;
    reg [ADDR_WIDTH-1:0] addr_i;
    reg [31:0] data_i;
    reg we_i;

    // Output
    wire [31:0] mem_o;

    // Instantiate DUT
    dmem #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_VAR(NUM_VAR)
    ) uut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .addr_i(addr_i),
        .data_i(data_i),
        .we_i(we_i),
        .mem_o(mem_o)
    );

    // Clock generation (10ns period)
    always #5 clk_i = ~clk_i;

    initial begin
        // Initialize
        clk_i  = 0;
        rst_ni = 0;
        addr_i = 0;
        data_i = 0;
        we_i   = 0;

        // Hold reset
        #12;
        rst_ni = 1;

        // ------------------------
        // Test 1: Write to reg 3
        // ------------------------
        @(posedge clk_i);
        addr_i = 5'd3;
        data_i = 32'hAAAA_BBBB;
        we_i   = 1;

        @(posedge clk_i);
        we_i = 0;

        // Read back reg 3
        @(posedge clk_i);
        addr_i = 5'd3;

        // ------------------------
        // Test 2: Write to reg 7
        // ------------------------
        @(posedge clk_i);
        addr_i = 5'd7;
        data_i = 32'h1234_5678;
        we_i   = 1;

        @(posedge clk_i);
        we_i = 0;

        // Read back reg 7
        @(posedge clk_i);
        addr_i = 5'd7;

        // ------------------------
        // Test 3: Reset again
        // ------------------------
        @(posedge clk_i);
        rst_ni = 0;

        @(posedge clk_i);
        rst_ni = 1;
        addr_i = 5'd3;

        @(posedge clk_i);

        $stop;
    end

endmodule