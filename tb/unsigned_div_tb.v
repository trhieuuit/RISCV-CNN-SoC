`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 04:31:50 PM
// Design Name: 
// Module Name: div_tb
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


module unsigned_div_tb;

    // Inputs
    reg         clk_i;
    reg         rst_n;
    reg         start_i;
    reg [31:0]  dividend_i;
    reg [31:0]  divisor_i;

    // Outputs
    wire [31:0] quotient_o;
    wire [31:0] remainder_o;
    wire        done_o;

    // Instantiate DUT
    unsigned_div uut (
        .clk_i(clk_i),
        .rst_n(rst_n),
        .start_i(start_i),
        .dividend_i(dividend_i),
        .divisor_i(divisor_i),
        .quotient_o(quotient_o),
        .remainder_o(remainder_o),
        .done_o(done_o)
    );

    // Clock generation (10ns period)
    always #2.5 clk_i = ~clk_i;

    // Task to run one test
    task run_test;
        input [31:0] a;
        input [31:0] b;
        begin
            @(posedge clk_i);
            dividend_i = a;
            divisor_i  = b;
            start_i    = 1;

            @(posedge clk_i);
            start_i = 0;

            // Wait for done
            wait(done_o == 1);

            $display("==================================");
            $display("Dividend = %d, Divisor = %d", a, b);
            $display("Quotient = %d, Remainder = %d",
                      quotient_o, remainder_o);

            if (b != 0) begin
                if (quotient_o == a / b &&
                    remainder_o == a % b)
                    $display("TEST PASSED");
                else
                    $display("TEST FAILED");
            end else begin
                if (quotient_o == 32'hFFFFFFFF)
                    $display("DIVIDE BY ZERO HANDLED CORRECTLY");
                else
                    $display("DIVIDE BY ZERO FAILED");
            end

            @(posedge clk_i);
        end
    endtask

    initial begin
        // Init
        clk_i = 0;
        rst_n = 0;
        start_i = 0;
        dividend_i = 0;
        divisor_i = 0;

        // Reset
        #20;
        rst_n = 1;

        // Test cases
        run_test(100, 5);
        run_test(37, 6);
        run_test(12345, 123);
        run_test(32'hFFFFFFFF, 2);
        run_test(532, 23);
        run_test(100, 0);     // Divide by zero

        #1000;
        $finish;
    end

endmodule
