`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2026 12:34:07 AM
// Design Name: 
// Module Name: alu_tb
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


    
`include "encoding.v"

module alu_tb;

    // Signal declaration
    reg  [31:0] tb_a, tb_b;
    reg  [4:0]  tb_op;
    wire [31:0] tb_out;

    // DUT Instantiation
    alu dut (
        .operand_a_i(tb_a),
        .operand_b_i(tb_b),
        .alu_op_i(tb_op),
        .alu_data_o(tb_out)
    );

    initial begin
        $display("--- START ALU SIMULATION ---");

        // 1. ADD: 10 + 5 = 15
        tb_a = 10; tb_b = 5; tb_op = `ADD; #10;
        check(32'd15);

        // 2. SUB: 20 - 5 = 15
        tb_a = 20; tb_b = 5; tb_op = `SUB; #10;
        check(32'd15);

        // 3. AND: 0xF0 & 0x0F = 0x00
        tb_a = 32'hF0; tb_b = 32'h0F; tb_op = `AND; #10;
        check(32'h00);

        // 4. OR: 0xF0 | 0x0F = 0xFF
        tb_a = 32'hF0; tb_b = 32'h0F; tb_op = `OR; #10;
        check(32'hFF);

        // 5. XOR: 0xFF ^ 0x0F = 0xF0
        tb_a = 32'hFF; tb_b = 32'h0F; tb_op = `XOR; #10;
        check(32'hF0);

        // 6. SLL: 1 << 4 = 16
        tb_a = 1; tb_b = 4; tb_op = `SLL; #10;
        check(32'd16);

        // 7. SRL: 32 >> 1 = 16
        tb_a = 32; tb_b = 1; tb_op = `SRL; #10;
        check(32'd16);

        // 8. SRA: -16 (0xFF...F0) >>> 2 = -4 (0xFF...FC)
        tb_a = -16; tb_b = 2; tb_op = `SRA; #10;
        check(-4); // Check arithmetic sign extension

        // 9. SLT (Signed): -10 < 10 -> True (1)
        tb_a = -10; tb_b = 10; tb_op = `SLT; #10;
        check(32'd1);

        // 10. SLTU (Unsigned): -1 (MaxUint) < 10 -> False (0)
        tb_a = -1; tb_b = 10; tb_op = `SLTU; #10;
        check(32'd0);

        $display("--- SIMULATION FINISHED ---");
        $finish;
    end

    // Task check result
    task check;
        input [31:0] expected;
        begin
            if (tb_out !== expected) 
                $display("[FAIL] Op: %b | A: %h | B: %h | Out: %h | Exp: %h", 
                         tb_op, tb_a, tb_b, tb_out, expected);
            else
                $display("[PASS] Op: %b | Out: %h", tb_op, tb_out);
        end
    endtask
endmodule
