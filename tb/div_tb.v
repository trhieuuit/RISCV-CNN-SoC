`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 05:10:17 PM
// Design Name: 
// Module Name: unsigned_div
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



module div_tb;

    reg clk;
    reg rst_n;
    reg start;
    reg is_signed;
    reg [31:0] rs1;
    reg [31:0] rs2;

    wire [31:0] quotient;
    wire [31:0] remainder;
    wire done;

    // DUT
    div dut (
        .clk_i(clk),
        .rst_n(rst_n),
        .start_i(start),
        .is_signed_i(is_signed),
        .rs1_i(rs1),
        .rs2_i(rs2),
        .quotient_o(quotient),
        .remainder_o(remainder),
        .done_o(done)
    );

    // 10ns clock
    initial clk = 0;
    always #5 clk = ~clk;

    // ================================
    // TASK: Safe Division Transaction
    // ================================
    task automatic do_div;
        input [31:0] a;
        input [31:0] b;
        input        signed_mode;

        reg [31:0] expected_q;
        reg [31:0] expected_r;

        begin
            // Wait until divider is idle
            @(posedge clk);

            rs1       <= a;
            rs2       <= b;
            is_signed <= signed_mode;
            start     <= 1'b1;

            @(posedge clk);
            start <= 1'b0;

            // Wait for done pulse
            wait(done == 1'b1);
            @(posedge clk);

            // ================================
            // Expected Result Calculation
            // ================================
            if (b == 0) begin
                expected_q = 32'hFFFFFFFF;
                expected_r = a;
            end
            else if (signed_mode) begin
                expected_q = $signed(a) / $signed(b);
                expected_r = $signed(a) % $signed(b);
            end
            else begin
                expected_q = a / b;
                expected_r = a % b;
            end

            // ================================
            // Check Result
            // ================================
            if (quotient !== expected_q || remainder !== expected_r) begin
                $display("ERROR");
                $display("a = %0d  b = %0d  signed=%0d", a, b, signed_mode);
                $display("Expected Q=%0d R=%0d", expected_q, expected_r);
                $display("Got      Q=%0d R=%0d", quotient, remainder);
                $stop;
            end
            else begin
                $display("PASS: a=%0d b=%0d signed=%0d | Q=%0d R=%0d",
                         a, b, signed_mode, quotient, remainder);
            end

            // Small spacing delay
            repeat (2) @(posedge clk);
        end
    endtask


    // ================================
    // TEST SEQUENCE
    // ================================
    initial begin
        rst_n = 0;
        start = 0;
        rs1   = 0;
        rs2   = 0;
        is_signed = 0;

        repeat (5) @(posedge clk);
        rst_n = 1;
        repeat (5) @(posedge clk);

        // UNSIGNED
        do_div(32'd20, 32'd3, 0);
        do_div(32'd100, 32'd10, 0);
        do_div(32'd55, 32'd0, 0);

        // SIGNED
        do_div(32'd20,  -32'd3, 1);
        do_div(-32'd20,  32'd3, 1);
        do_div(-32'd20, -32'd3, 1);
        do_div(-32'd100, 32'd10, 1);

        // Random testing
        repeat (20) begin
            do_div($random, $random, 1'b0);
            do_div($random, $random, 1'b1);
        end

        $display("🎉 ALL TESTS PASSED");
        $finish;
    end

endmodule