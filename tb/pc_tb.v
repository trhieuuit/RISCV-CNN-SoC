`timescale 1ns / 1ps

module pc_tb;

    // Inputs
    reg clk_i;
    reg rst_ni;
    reg branch_i;
    reg [31:0] jaddr_i;

    // Output
    wire [31:0] pc_o;

    // Instantiate DUT (Device Under Test)
    pc uut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .branch_i(branch_i),
        .jaddr_i(jaddr_i),
        .pc_o(pc_o)
    );

    // Clock generation (10ns period → 100 MHz)
    always #5 clk_i = ~clk_i;

    initial begin
        // Initialize signals
        clk_i   = 0;
        rst_ni  = 0;
        branch_i = 0;
        jaddr_i = 0;

        // Hold reset for a few cycles
        #12;
        rst_ni = 1;

        // Let PC increment normally
        #40;

        // Trigger branch
        branch_i = 1;
        jaddr_i  = 32'h00000020;
        #10;

        // Disable branch → continue increment
        branch_i = 0;
        #40;

        // Another branch
        branch_i = 1;
        jaddr_i  = 32'h00000080;
        #10;
        branch_i = 0;

        #40;

        $stop;  // Stop simulation
    end

endmodule
