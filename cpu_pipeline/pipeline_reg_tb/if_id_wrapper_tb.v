`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2026 05:24:13 PM
// Design Name: 
// Module Name: if_id_wrapper_tb
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

`timescale 1ns/1ps

module if_id_wrapper_tb;

    reg clk;
    reg rst_n;
    reg branch;
    reg [31:0] jaddr;
    reg flush;
    reg stall;

    wire [31:0] pc_out;
    wire [31:0] imem_out;

    // DUT
    if_id_wrapper DUT (
        .clk_i(clk),
        .rst_ni(rst_n),
        .branch_i(branch),
        .jaddr_i(jaddr),
        .stall_i(stall),
        .flush_i(flush),
        .pc_o(pc_out),
        .imem_o(imem_out)
    );

    // Clock generation
    always #5 clk = ~clk;   // 10ns period

    initial begin
        clk = 0;
        rst_n = 0;
        branch = 0;
        jaddr = 0;
        stall = 0;

        // Reset phase
        #20;
        rst_n = 1;

        // Let PC increment
        #40;

        // Trigger branch
        branch = 1;
        jaddr = 32'd40;
        #10;
        branch = 0;

        #40;

        // Trigger stall
        stall = 1;
        #30;
        stall = 0;

        #50;

        $finish;
    end

endmodule
