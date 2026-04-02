`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hieu
// Create Date: 02/06/2026
// Module Name: imme_gen_tb
// Description: Testbench for RISC-V Immediate Generator
//////////////////////////////////////////////////////////////////////////////////
`include "encoding.v" 

module imme_gen_tb();
	
    // 1. Signal Declarations
    reg  [24:0] tb_in;       // Mock instruction[31:7]
    reg  [2:0]  tb_imm_sel;  // Control signal for immediate type
    wire [31:0] tb_out;      // Generated immediate output

    // 2. Design Under Test (DUT) Instantiation
    imme_gen dut (
        .in(tb_in),
        .imm_sel(tb_imm_sel),
        .out(tb_out)
    );

    // Error counter
    integer errors = 0;

    // 3. Test Stimulus Block
    initial begin
        $display("----------------------------------------------------------------");
        $display("STARTING SIMULATION FOR IMM_GEN");
        $display("----------------------------------------------------------------");
        
        // --- CASE 1: I-TYPE (SIGNED) ---
        // Mock: ADDI x1, x0, -1 (Expected Imm: 0xFFFFFFFF)
        $display("Test Case 1: I-Type Signed (Negative Value)");
        tb_imm_sel = `I_SIGNED_TYPE;
        tb_in      = {1'b1, 11'h7FF, 13'd0}; // Sign bit=1, imm[11:0]=0x7FF
        #10;
        check_result(32'hFFFFFFFF);

        // --- CASE 2: U-TYPE ---
        // Mock: LUI (Load Upper Immediate)
        // Shift in[24:5] to out[31:12]
        $display("Test Case 2: U-Type (Upper Immediate)");
        tb_imm_sel = `U_TYPE;
        tb_in      = {20'hAAAAA, 5'b00000}; 
        #10;
        check_result(32'hAAAAA000); 

        // --- CASE 3: S-TYPE (STORE) ---
        // Immediate split between in[24:18] and in[4:0]
        // Target: 0x0000001F (31 decimal)
        $display("Test Case 3: S-Type (Store offset)");
        tb_imm_sel = `S_TYPE;
        tb_in      = 25'b0_000000_00000_00000_11111;
        #10;
        check_result(32'h0000001F);

        // --- CASE 4: B-TYPE (BRANCH) ---
        // Scrambled bits with sign extension
        $display("Test Case 4: B-Type (Branch Negative)");
        tb_imm_sel = `B_TYPE;
        tb_in      = 25'h1000001;
        #10;
        check_result(32'hFFFFF800);

        // --- CASE 5: J-TYPE (JUMP) ---
        // Logic for JAL instruction
        $display("Test Case 5: J-Type (Jump)");
        tb_imm_sel = `J_TYPE;
        tb_in      = 25'b0_00000000000_11111111_00000; // bit [19:12] set to 1
        #10;
        check_result(32'h000FF000); 

        // --- SUMMARY ---
        $display("----------------------------------------------------------------");
        if (errors == 0) 
            $display("SUCCESS: ALL TESTS PASSED!");
        else 
            $display("FAILURE: %d ERRORS FOUND.", errors);
        $display("----------------------------------------------------------------");
        $finish; 
    end

    // --- Helper Task: Automatic Result Verification ---
    task check_result;
        input [31:0] expected;
        begin
            if (tb_out === expected) begin
                $display("    [PASS] Time: %0t | Sel: %b | Out: %h", $time, tb_imm_sel, tb_out);
            end else begin
                $display("    [FAIL] Time: %0t | Sel: %b | Out: %h | Expected: %h", $time, tb_imm_sel, tb_out, expected);
                errors = errors + 1;
            end
        end
    endtask
endmodule