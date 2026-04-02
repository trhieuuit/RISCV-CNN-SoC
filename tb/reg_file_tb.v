`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hieu
// Create Date: 02/04/2026
// Module Name: reg_file_tb
// Description: Self-checking testbench for RISC-V Register File
//////////////////////////////////////////////////////////////////////////////////

module reg_file_tb();

    // --- 1. SIGNAL DECLARATIONS ---
    parameter DATA_WIDTH = 32;
    parameter NUM_REGS   = 32;
    parameter ADDR_WIDTH = 5;

    reg clk_i;
    reg rst_ni;
    reg we_i;
    reg [ADDR_WIDTH-1:0] raddr1_i, raddr2_i, waddr_i;
    reg [DATA_WIDTH-1:0] wdata_i;
    wire [DATA_WIDTH-1:0] rdata1_o, rdata2_o;

    // Error counter
    integer error_count = 0;

    // --- 2. DUT INSTANTIATION ---
    reg_file #(
        .DATA_WIDTH(DATA_WIDTH), 
        .NUM_REGS(NUM_REGS)
    ) dut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .we_i(we_i),
        .raddr1_i(raddr1_i),
        .raddr2_i(raddr2_i),
        .waddr_i(waddr_i),
        .wdata_i(wdata_i),
        .rdata1_o(rdata1_o),
        .rdata2_o(rdata2_o)
    );

    // --- 3. CLOCK GENERATION (100MHz) ---
    always #5 clk_i = ~clk_i;

    // --- 4. HELPER TASKS ---
    
    // Task 1: Perform Write operation
    task write_reg(input [4:0] addr, input [31:0] data);
        begin
            @(posedge clk_i); // Wait for rising edge
            we_i = 1;
            waddr_i = addr;
            wdata_i = data;
            @(posedge clk_i); // Wait for write completion
            we_i = 0;
            waddr_i = 0;      // Clear buses
            wdata_i = 0;
        end
    endtask

    // Task 2: Automatic Verification (Check)
    task check_reg(input [4:0] addr, input [31:0] expected_val);
        begin
            raddr1_i = addr;
            #1; // Small delay for combinational logic stabilization
            
            if (rdata1_o !== expected_val) begin
                $display("[FAIL] Time %0t: Addr x%0d | Expected: %h | Actual: %h", 
                         $time, addr, expected_val, rdata1_o);
                error_count = error_count + 1;
            end else begin
                $display("[PASS] Time %0t: Addr x%0d == %h", $time, addr, rdata1_o);
            end
        end
    endtask

    // --- 5. MAIN STIMULUS ---
    initial begin
        // Initialization
        clk_i = 0;
        rst_ni = 1;
        we_i = 0;
        raddr1_i = 0; raddr2_i = 0;
        waddr_i = 0; wdata_i = 0;
        
        $display("---------------------------------------");
        $display("STARTING SELF-CHECKING TESTBENCH");
        $display("---------------------------------------");

        // TEST 1: RESET CHECK
        // Apply Reset
        rst_ni = 0; #10;
        rst_ni = 1; #10;
        
        // Verify random registers are cleared to zero
        check_reg(1, 32'h0);
        check_reg(31, 32'h0);

        // TEST 2: SINGLE WRITE & READ
        // Write to x1 and x2
        write_reg(5'd1, 32'hDEADBEEF);
        write_reg(5'd2, 32'hCAFEBABE);
        
        // Verify values
        check_reg(1, 32'hDEADBEEF);
        check_reg(2, 32'hCAFEBABE);

        // TEST 3: x0 HARDWIRED ZERO PROTECTION
        // Attempt to write to x0
        write_reg(5'd0, 32'hFFFFFFFF);
        
        // Verify x0 remains zero
        check_reg(0, 32'h00000000);

        // TEST 4: OVERWRITE CHECK
        // Overwrite x1 with new value
        write_reg(5'd1, 32'h12345678);
        check_reg(1, 32'h12345678);

        // --- SUMMARY ---
        $display("---------------------------------------");
        if (error_count == 0) begin
            $display("RESULT: SUCCESS! All tests passed.");
        end else begin
            $display("RESULT: FAILED! Found %0d errors.", error_count);
        end
        $display("---------------------------------------");
        
        $finish;
    end

endmodule