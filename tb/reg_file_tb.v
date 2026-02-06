`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2026 09:00:11 PM
// Design Name: 
// Module Name: reg_file_tb
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


module reg_file_tb();
	

    // --- 1. KHAI BÁO TÍN HIỆU ---
    parameter DATA_WIDTH = 32;
    parameter NUM_REGS   = 32;
    parameter ADDR_WIDTH = 5;

    reg clk_i;
    reg rst_ni;
    reg we_i;
    reg [ADDR_WIDTH-1:0] raddr1_i, raddr2_i, waddr_i;
    reg [DATA_WIDTH-1:0] wdata_i;
    wire [DATA_WIDTH-1:0] rdata1_o, rdata2_o;

    // Biến đếm số lỗi
    integer error_count = 0;

    // --- 2. INSTANTIATE DUT ---
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

    // --- 3. TẠO CLOCK (100MHz) ---
    always #5 clk_i = ~clk_i;

    // --- 4. CÁC TASKS (HÀM HỖ TRỢ) ---
    
    // Task 1: Thực hiện thao tác Ghi (Write)
    task write_reg(input [4:0] addr, input [31:0] data);
        begin
            @ (posedge clk_i); // Đợi cạnh lên clock
            we_i = 1;
            waddr_i = addr;
            wdata_i = data;
            @ (posedge clk_i); // Đợi ghi xong
            we_i = 0;
            waddr_i = 0; // Xóa bus cho sạch
            wdata_i = 0;
        end
    endtask

    // Task 2: Tự động kiểm tra (Check)
    task check_reg(input [4:0] addr, input [31:0] expected_val);
        begin
            raddr1_i = addr;
            #1; // Delay nhỏ để mạch tổ hợp ổn định
            
            if (rdata1_o !== expected_val) begin
                $display("[FAIL] Time %0t: Addr x%0d | Expected: %h | Actual: %h", 
                         $time, addr, expected_val, rdata1_o);
                error_count = error_count + 1;
            end else begin
                $display("[PASS] Time %0t: Addr x%0d == %h", $time, addr, rdata1_o);
            end
        end
    endtask

    // --- 5. CHƯƠNG TRÌNH CHÍNH ---
    initial begin
        // Khởi tạo
        clk_i = 0;
        rst_ni = 1;
        we_i = 0;
        raddr1_i = 0; raddr2_i = 0;
        waddr_i = 0; wdata_i = 0;
        
        $display("---------------------------------------");
        $display("STARTING SELF-CHECKING TESTBENCH");
        $display("---------------------------------------");

        // TEST 1: RESET CHECK
        // Reset mạch
        rst_ni = 0; #10;
        rst_ni = 1; #10;
        
        // Kiểm tra vài thanh ghi ngẫu nhiên xem có về 0 hết không
        check_reg(1, 32'h0);
        check_reg(31, 32'h0);

        // TEST 2: SINGLE WRITE & READ
        // Ghi vào x1 và x2
        write_reg(5'd1, 32'hDEADBEEF);
        write_reg(5'd2, 32'hCAFEBABE);
        
        // Kiểm tra lại
        check_reg(1, 32'hDEADBEEF);
        check_reg(2, 32'hCAFEBABE);

        // TEST 3: x0 HARDWIRED ZERO PROTECTION
        // Cố tình ghi vào x0
        write_reg(5'd0, 32'hFFFFFFFF);
        
        // Kiểm tra xem x0 có vẫn là 0 không
        check_reg(0, 32'h00000000);

        // TEST 4: OVERWRITE CHECK
        // Ghi đè giá trị mới vào x1
        write_reg(5'd1, 32'h12345678);
        check_reg(1, 32'h12345678);

        // --- TỔNG KẾT ---
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

