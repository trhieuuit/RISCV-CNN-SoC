`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2026 07:54:40 AM
// Design Name: 
// Module Name: mul_tb
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

module mul_tb;

    // Signals
    reg  [31:0] tb_a, tb_b;
    reg  [4:0]  tb_op;
    wire [31:0] tb_out;

    // DUT
    mul dut (
        .mul_a_i(tb_a),
        .mul_b_i(tb_b),
        .mul_op_i(tb_op),
        .mul_data_o(tb_out)
    );

    initial begin
        $display("--- SIMULATION START ---");

        // 1. MUL: 10 * -5 = -50 (FFFFFFCE)
        tb_a = 10; tb_b = -5; tb_op = `MUL; #10;
        check(32'hFFFFFFCE);

        // 2. MULH (Signed): -1 * -1 = 1 (High part = 0)
        tb_a = -1; tb_b = -1; tb_op = `MULH; #10;
        check(32'h00000000);

        // 3. MULHU (Unsigned): MaxUint * 2
        // FFFFFFFF * 2 = 1_FFFFFFFE -> High part = 1
        tb_a = 32'hFFFFFFFF; tb_b = 2; tb_op = `MULHU; #10;
        check(32'h00000001);

        // 4. MULHSU (Signed x Unsigned): -1 * 2
        // -1 (signed) * 2 (unsigned) = -2 (64-bit: F...F_E) -> High = F...F
        tb_a = -1; tb_b = 2; tb_op = `MULHSU; #10;
        check(32'hFFFFFFFF);

        $display("--- FINISHED ---");
        $finish;
    end

    // Task check
    task check;
        input [31:0] exp;
        begin
            if (tb_out !== exp) 
                $display("FAIL | Op:%b | A:%h B:%h | Out:%h Exp:%h", tb_op, tb_a, tb_b, tb_out, exp);
            else 
                $display("PASS | Op:%b | Out:%h", tb_op, tb_out);
        end
    endtask

endmodule