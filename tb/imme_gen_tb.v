`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2026 12:07:09 PM
// Design Name: 
// Module Name: imme_gen_tb
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

module imme_gen_tb();
	
	// 1. Khai báo tín hiệu
    reg  [24:0] tb_in;       // Giả lập instruction[31:7]
    reg  [2:0]  tb_imm_sel;  // Tín hiệu điều khiển
    wire [31:0] tb_out;      // Kết quả đầu ra

    // 2. Gọi module cần test (DUT - Device Under Test)
    imme_gen dut (
        .in(tb_in),
        .imm_sel(tb_imm_sel),
        .out(tb_out)
    );

    // Biến phụ để check kết quả đúng sai (tùy chọn)
    integer errors = 0;

    // 3. Khối khởi tạo và chạy test
    initial begin
        $display("----------------------------------------------------------------");
        $display("STARTING SIMULATION FOR IMM_GEN");
        $display("----------------------------------------------------------------");
        
        // --- TRƯỜNG HỢP 1: I-TYPE (SIGNED) ---
        // Giả lập lệnh ADDI x1, x0, -1 (Instruction: 0xFFF00093)
        // Immediate mong muốn: 0xFFFFFFFF (-1)
        // input in = instruction[31:7] = 25'b1_11111111111_00000_00000_00 (Đại khái)
        // Cụ thể: in[24:13] là imm[11:0]. Cho tất cả bằng 1 để test số âm.


$display("Test Case 1: I-Type Signed (Negative Value)");
        tb_imm_sel = `I_SIGNED_TYPE;
        // {1 bit dấu, 11 bit 1, 13 bit 0} = 25 bit chuẩn
        tb_in      = {1'b1, 11'h7FF, 13'd0}; 
        #10;
        check_result(32'hFFFFFFFF);
        // --- TRƯỜNG HỢP 2: U-TYPE ---
        // Lệnh LUI (Load Upper Immediate)
        // input in[24:5] sẽ được đưa vào out[31:12]
        // Cho pattern 0xAAAAA vào 20 bit cao
        $display("Test Case 2: U-Type (Upper Immediate)");
        tb_imm_sel = `U_TYPE;
        // in[24:5] = 0xAAAAA (20 bit 1010...)
        tb_in      = {20'hAAAAA, 5'b00000}; 
        #10;
        check_result(32'hAAAAA000); // Mong đợi 20 bit cao là AAAAA, 12 bit thấp là 0

        // --- TRƯỜNG HỢP 3: S-TYPE (STORE) ---
        // Immediate bị chia làm 2 phần: in[24:18] và in[4:0]
        // Giả sử muốn tạo số: 0x0000001F (31 decimal)
        // 5 bit thấp (in[4:0]) = 11111
        // 7 bit cao (in[24:18]) = 0000000
        $display("Test Case 3: S-Type (Store offset)");
        tb_imm_sel = `S_TYPE;
        tb_in      = 25'b0_000000_00000_00000_11111;
        #10;
        check_result(32'h0000001F);

        // --- TRƯỜNG HỢP 4: B-TYPE (BRANCH) - QUAN TRỌNG ---
        // B-Type xáo trộn bit rất nhiều. 
        // Test bit dấu (bit 31 -> in[24]) và bit 11 (bit 7 -> in[0])
        // Giả sử ta set in[24]=1 (số âm) và in[0]=1 (bit 11 bật)


$display("Test Case 4: B-Type (Branch Negative)");
        tb_imm_sel = `B_TYPE;
        // Sign=1, Bit 11=0 (để ra F800), các bit khác 0
        // {1 bit 1, 23 bit 0, 1 bit 0}
     //   tb_in      = {1'b1, 23'd0, 1'b0}; 
        tb_in      = 25'h1000001;
        #10;
        check_result(32'hFFFFF800);
        // --- TRƯỜNG HỢP 5: J-TYPE (JUMP) ---
        // Test logic JAL
        // Test bit [19:12] lấy từ in[12:5]
        $display("Test Case 5: J-Type (Jump)");
        tb_imm_sel = `J_TYPE;
        // in[12:5] = 8'hFF (tất cả là 1), in[24]=0 (số dương)
        // Mong đợi: bit [19:12] của output sẽ là 1
        tb_in      = 25'b0_00000000000_11111111_00000;
        #10;
        // Output mong đợi: 00...00_0000_1111_1111_0000_0000_000 (Bit 19:12 bật)
        // Hex: 0x000FF000
        check_result(32'h000FF000); 

        // --- TỔNG KẾT ---
        $display("----------------------------------------------------------------");
        if (errors == 0) 
            $display("SUCCESS: ALL TESTS PASSED! CONGRATS!");
        else 
            $display("FAILURE: FOUND %d ERRORS.", errors);
        $display("----------------------------------------------------------------");
        $finish; // Kết thúc mô phỏng
    end

    // --- Task hỗ trợ kiểm tra kết quả tự động ---
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
